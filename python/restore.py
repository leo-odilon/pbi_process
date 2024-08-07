import os
import glob
import argparse

def revert_excel_names(folder_path):
    # Encontrar todos os arquivos .bak na pasta
    bak_files = glob.glob(os.path.join(folder_path, '*.bak'))
    
    # Verificar se existem arquivos .bak na pasta
    if not bak_files:
        raise FileNotFoundError("Nenhum arquivo .bak encontrado na pasta especificada.")
    
    # Reverter cada nome de arquivo .bak para .xlsx
    for file_path in bak_files:
        try:
            # Construir o novo nome de arquivo removendo o timestamp e .bak
            base_name = os.path.splitext(file_path)[0]
            new_file_path = f"{base_name}.xlsx"
            
            # Renomear o arquivo
            os.rename(file_path, new_file_path)
            print(f"Renomeado: {file_path} para {new_file_path}")
        except Exception as e:
            print(f"Erro ao renomear {file_path}: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Revert the names of Excel files by removing timestamp and .bak extension, and adding .xlsx.')
    parser.add_argument('folder_path', type=str, help='Caminho da pasta contendo arquivos .bak')

    args = parser.parse_args()

    # Verificar se a pasta de entrada existe
    if not os.path.isdir(args.folder_path):
        raise NotADirectoryError(f"A pasta {args.folder_path} não existe.")

    revert_excel_names(args.folder_path)
