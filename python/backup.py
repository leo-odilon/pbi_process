import os
import glob
import time
import argparse

def rename_excel_files(folder_path):
    # Encontrar todos os arquivos Excel na pasta
    excel_files = glob.glob(os.path.join(folder_path, '*.xlsx'))
    
    # Verificar se existem arquivos Excel na pasta
    if not excel_files:
        raise FileNotFoundError("Nenhum arquivo Excel encontrado na pasta especificada.")
    
    # Renomear cada arquivo Excel
    for file_path in excel_files:
        try:
            timestamp = time.strftime('%Y%m%d_%H%M%S')
            new_file_path = f"{os.path.splitext(file_path)[0]}_{timestamp}.bak"
            os.rename(file_path, new_file_path)
            print(f"Renomeado: {file_path} para {new_file_path}")
        except Exception as e:
            print(f"Erro ao renomear {file_path}: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Rename Excel files in a folder by adding a timestamp and .bak extension.')
    parser.add_argument('folder_path', type=str, help='Caminho da pasta contendo arquivos Excel')

    args = parser.parse_args()

    # Verificar se a pasta de entrada existe
    if not os.path.isdir(args.folder_path):
        raise NotADirectoryError(f"A pasta {args.folder_path} não existe.")

    rename_excel_files(args.folder_path)
