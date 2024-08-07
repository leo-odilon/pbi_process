import pandas as pd
import pyarrow
import argparse
import os
import glob
import time

def process_excel_to_parquet(file_path, sheet_name, skip_rows, output_folder, parquet_name):
    # Verificar se a pasta de saída existe, se não, criá-la
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Verificar se o nome da planilha foi fornecido
    if sheet_name:
        # Ler o arquivo Excel com o nome da planilha especificado
        df = pd.read_excel(file_path, sheet_name=sheet_name, skiprows=skip_rows)
    else:
        # Ler o arquivo Excel usando a primeira planilha por padrão
        df = pd.read_excel(file_path, skiprows=skip_rows)
    
    # Normalizar os nomes das colunas
    df.columns = [col.lower()
                    .replace('.', '')
                    .replace('/', '_')
                    .replace('(', '')
                    .replace(')', '')
                    .replace(' ', '_')
                    .replace('\n', '_') 
                  for col in df.columns]

    # Construir o caminho do arquivo de saída com timestamp
    timestamp = time.strftime('%Y%m%d_%H%M%S')
    output_file_path = f'{output_folder}/{parquet_name}_{timestamp}.parquet'
    
    # Salvar o DataFrame em formato Parquet
    df.to_parquet(output_file_path, index=False)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process Excel files in a folder to Parquet.')
    parser.add_argument('folder_path', type=str, help='Caminho da pasta contendo arquivos Excel')
    parser.add_argument('--sheet_name', type=str, default=None, help='Nome da tabela (opcional)')
    parser.add_argument('skip_rows', type=int, help='Quantidade de linhas para ignorar no começo')
    parser.add_argument('output_folder', type=str, help='Nome da pasta de saída')
    parser.add_argument('parquet_name', type=str, help='Nome base do arquivo Parquet')

    args = parser.parse_args()

    # Verificar se a pasta de entrada existe
    if not os.path.isdir(args.folder_path):
        raise NotADirectoryError(f"A pasta {args.folder_path} não existe.")
    
    # Encontrar todos os arquivos Excel na pasta
    excel_files = glob.glob(os.path.join(args.folder_path, '*.xlsx'))
    
    # Verificar se existem arquivos Excel na pasta
    if not excel_files:
        raise FileNotFoundError("Nenhum arquivo Excel encontrado na pasta especificada.")
    
    # Processar cada arquivo Excel encontrado
    for file_path in excel_files:
        try:
            process_excel_to_parquet(file_path, args.sheet_name, args.skip_rows, args.output_folder, args.parquet_name)
            print(f"Processado: {file_path}")
        except Exception as e:
            print(f"Erro ao processar {file_path}: {e}")
