import sys                # Importamos el módulo sys para acceder a los argumentos de la línea de comandos.
from pathlib import Path  # Importamos Path de pathlib para manejar rutas de archivos de manera más eficiente y compatible con diferentes sistemas operativos.
import shutil             # Importamos shutil para copiar archivos, en este caso, para copiar la plantilla de Lambda a la nueva ubicación.


def main():
    if len(sys.argv) < 2: # Verificamos si se ha proporcionado el nombre de la Lambda como argumento. Si no es así, mostramos un mensaje de error y salimos del programa.
        print("Error: debes indicar el nombre de la Lambda.")
        print("Uso: python create_lambda.py <lambda_name>")
        sys.exit(1) # Salimos del programa con un código de error (1) para indicar que hubo un problema con los argumentos proporcionados.

    lambda_name = sys.argv[1] #Asignamos el valor siguiente al nombre de la Lambda, que es el primer argumento después del nombre del script. (python create_lambda.py MiLambda -> lambda_name = "MiLambda")

    base_path = Path(__file__).resolve().parent.parent  # Obtenemos la ruta base del proyecto. __file__ es la ruta del script actual, resolve() obtiene la ruta absoluta, parent.parent sube dos niveles para llegar a la raíz del proyecto.
    template_path = base_path / "templates" / "lambda_function.py" #Ruta de la plantilla 
    target_path = base_path / lambda_name   #Define donde se creará la nueva Lambda
    target_file = target_path / "lambda_function.py"
    if target_path.exists():
        print(f"Error: la Lambda '{lambda_name}' ya existe.")
        sys.exit(1)

    target_path.mkdir()
    print("Template:", template_path) #Mostramos la ruta de la plantilla para verificar que es correcta. Esto es útil para depuración y asegurarnos de que estamos copiando el archivo correcto.
    print("Target:", target_file) #Mostramos la ruta de destino para verificar que es correcta. Esto es útil para depuración y asegurarnos de que estamos copiando el archivo al lugar correcto.
    shutil.copy(template_path, target_file) # Copiamos el archivo de la plantilla a la nueva ubicación, creando así la estructura básica de la Lambda.

    print(f"Lambda '{lambda_name}' creada correctamente.")
    print(f"Ruta: {target_path}")


if __name__ == "__main__":
    main()
