#pragma once

#include <string>
#include <glm/glm.hpp>

class Shader {
private:
  void check_compile_errors_(unsigned int shader, std::string type) const;

public:
  unsigned int id_;

  Shader(const char *vertex_path, const char *fragment_path);

  void use() const;
  void set_bool(const std::string &name, bool value) const;
  void set_int(const std::string &name, int value) const;
  void set_float(const std::string &name, float value) const;
  void set_vec2f(const std::string &name, glm::vec2 value) const;
  void set_vec3f(const std::string &name, glm::vec3 value) const;
  void set_uvec3f(const std::string &name, glm::uvec3 value) const;
  void set_mat4f(const std::string &name, glm::mat4 matrix) const;
};
