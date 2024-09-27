#include "shader.hpp"

#include <glad/glad.h>
#include <glm/gtc/type_ptr.hpp>

#include <fstream>
#include <sstream>
#include <iostream>

Shader::Shader(const char *vertex_path, const char *fragment_path) {
  std::string vertex_code;
  std::string fragment_code;
  std::ifstream vert_shader_file;
  std::ifstream frag_shader_file;

  vert_shader_file.exceptions(std::ifstream::failbit | std::ifstream::badbit);
  frag_shader_file.exceptions(std::ifstream::failbit | std::ifstream::badbit);

  try {
    vert_shader_file.open(vertex_path);
    frag_shader_file.open(fragment_path);
    std::stringstream vert_shader_stream, frag_shader_stream;

    vert_shader_stream << vert_shader_file.rdbuf();
    frag_shader_stream << frag_shader_file.rdbuf();

    vert_shader_file.close();
    frag_shader_file.close();

    vertex_code = vert_shader_stream.str();
    fragment_code = frag_shader_stream.str();
  } catch (std::ifstream::failure &e) {
    std::cout << "ERROR::SHADER::FILE::NOT_SUCCESSFULLY_READ: " << e.what()
              << std::endl;
  }

  const char *vert_shader_code = vertex_code.c_str();
  const char *frag_shader_code = fragment_code.c_str();

  unsigned int vertex, fragment;

  vertex = glCreateShader(GL_VERTEX_SHADER);
  glShaderSource(vertex, 1, &vert_shader_code, NULL);
  glCompileShader(vertex);
  check_compile_errors_(vertex, "VERTEX");

  fragment = glCreateShader(GL_FRAGMENT_SHADER);
  glShaderSource(fragment, 1, &frag_shader_code, NULL);
  glCompileShader(fragment);
  check_compile_errors_(fragment, "FRAGMENT");

  id_ = glCreateProgram();
  glAttachShader(id_, vertex);
  glAttachShader(id_, fragment);
  glLinkProgram(id_);
  check_compile_errors_(id_, "PROGRAM");

  glDeleteShader(vertex);
  glDeleteShader(fragment);
}

void Shader::use() const { glUseProgram(id_); }

void Shader::set_int(const std::string &name, int value) const {
  glUniform1i(glGetUniformLocation(id_, name.c_str()), value);
}

void Shader::set_float(const std::string &name, float value) const {
  glUniform1f(glGetUniformLocation(id_, name.c_str()), value);
}

void Shader::set_vec2f(const std::string &name, glm::vec2 value) const {
  glUniform2f(glGetUniformLocation(id_, name.c_str()), value.x, value.y);
}

void Shader::set_vec3f(const std::string &name, glm::vec3 value) const {
  glUniform3f(glGetUniformLocation(id_, name.c_str()), value.x, value.y,
              value.z);
}

void Shader::set_uvec3f(const std::string &name, glm::uvec3 value) const {
  glUniform3f(glGetUniformLocation(id_, name.c_str()), value.x, value.y,
              value.z);
}

void Shader::set_mat4f(const std::string &name, glm::mat4 value) const {
  glUniformMatrix4fv(glGetUniformLocation(id_, name.c_str()), 1, GL_FALSE,
                     glm::value_ptr(value));
}

void Shader::check_compile_errors_(unsigned int shader,
                                   std::string type) const {
  int success;
  char info_log[1024];
  if (type != "PROGRAM") {
    glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
    if (!success) {
      glGetShaderInfoLog(shader, 1024, NULL, info_log);
      std::cout << "ERROR::SHADER::COMPILATION of type: " << type << "\n"
                << info_log << std::endl;
    }
  } else {
    glGetProgramiv(shader, GL_LINK_STATUS, &success);
    if (!success) {
      glGetProgramInfoLog(shader, 1024, NULL, info_log);
      std::cout << "ERROR::PROGRAM_LINKING ERROR of type: " << type << "\n"
                << info_log << std::endl;
    }
  }
}
