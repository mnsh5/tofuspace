require "option_parser"
require "fileutils"

module TerraformFramework
  class ProjectGenerator
    # Método para generar la estructura del proyecto Terraform
    def self.generate_project(project_name : String)
      Dir.mkdir(project_name)
      FileUtils.mkdir_p("#{project_name}/modules")
      FileUtils.mkdir_p("#{project_name}/environments")
      File.write("#{project_name}/main.tf", "# Configuración principal de Terraform")
      File.write("#{project_name}/variables.tf", "# Variables de Terraform")
      File.write("#{project_name}/outputs.tf", "# Salidas de Terraform")
      puts "¡Estructura del proyecto Terraform generada en '#{project_name}'!"
    end

    # Método para generar un nuevo módulo
    def self.generate_module(module_name : String, parent_dir : String = "modules")
      module_dir = "#{parent_dir}/#{module_name}"
      if Dir.exist?(module_dir)
        puts "El módulo '#{module_name}' ya existe en '#{parent_dir}'."
      else
        FileUtils.mkdir_p(module_dir)
        generate_module_files(module_dir, module_name)
        puts "Módulo '#{module_name}' generado en '#{module_dir}'"
      end
    end

    # Método para generar los archivos de un módulo
    def self.generate_module_files(module_dir : String, module_name : String)
      File.write("#{module_dir}/main.tf", "# Configuración del módulo #{module_name}")
      File.write("#{module_dir}/variables.tf", "# Variables del módulo #{module_name}")
      File.write("#{module_dir}/outputs.tf", "# Salidas del módulo #{module_name}")
    end
  end

  class CLI
    # Método para parsear los argumentos de la línea de comandos
    def self.parse_args
      OptionParser.parse do |parser|
        parser.banner = "Usage: terra [command] [options]"
        parser.separator ""
        parser.separator "Commands:"
        parser.separator "  new project      Create a new Terraform project"
        parser.separator "  new module       Create a new Terraform module"
        parser.separator "  new resource     Create a new Terraform resource"

        parser.separator ""
        parser.separator "Options:"

        parser.on("-n NAME", "--name=NAME", "Nombre del proyecto, módulo o recurso Terraform") do |name|
          options[:name] = name
        end

        parser.on("-p PARENT_DIR", "--parent-dir=PARENT_DIR", "Directorio padre donde crear el módulo (por defecto: modules)") do |parent_dir|
          options[:parent_dir] = parent_dir
        end

        parser.on("-h", "--help", "Mostrar ayuda") do
          puts parser
          exit
        end
      end
    end
  end
end

# Función principal que maneja la interfaz de línea de comandos
def main
  command = ARGV.shift
  case command
  when "new"
    subcommand = ARGV.shift
    case subcommand
    when "project"
      TerraformFramework::ProjectGenerator.generate_project(TerraformFramework::CLI.options[:name])
    when "module"
      TerraformFramework::ProjectGenerator.generate_module(TerraformFramework::CLI.options[:name], TerraformFramework::CLI.options[:parent_dir])
    when "resource"
      # Aún no se ha implementado la creación de recursos dentro de módulos
      puts "El comando 'new resource' aún no está implementado."
    else
      puts "Comando desconocido: terra new #{subcommand}"
    end
  else
    puts "Comando desconocido: terra #{command}"
  end
end

TerraformFramework::CLI.parse_args
main
