# macOS 下使用 VSCode 配置 OpenGL 开发环境

## 参考

### 开发工具

-   安装 gcc/g++，可以使用 brew 工具进行安装

-   vscode 插件 [`C/C++`](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)、[`C/C++ Project Generator`](https://marketplace.visualstudio.com/items?itemName=danielpinto8zz6.c-cpp-project-generator)

### GLFW

-   brew 安装 glfw

-   glfw 下载 [`64 bit macOS binaries`](https://www.glfw.org/download.html)

    > 由于此处我是 M1 芯片，因此将其中 arm 的库拷贝到 ~~该工程下的 lib 目录下~~ `/usr/local/lib` 目录下。要注意，不同芯片编译出来的库指令集是不一样的。
    >> 上面被划掉的内容，由于我个人不知道该怎么放在当前目录下能被 makefile 包含到，因此只能放在全局路径下了，如果有更好的解决方案，欢迎来提 PR

### GLAD

-   glad [在线服务](https://glad.dav1d.de/) 生成静态库
    ```shell
    $ gcc ./src/glad.c -c -I ./include/   # 生成 .o文件
    $ ar -rc libglad.a glad.o             # 生成我们所需要的 .a文件
    ```
-   将生成的 libglad.a 复制到 lib 文件下

### Assimp

-   克隆 [assimp 库](https://github.com/assimp/assimp.git)，如果嫌克隆慢，可以加参数 `--depth=1`，或者用国内代理镜像源
    ```shell
    $ git clone https://github.com/assimp/assimp.git
    ```
-   使用 CMake 工具进行编译（编译教程来自 <https://github.com/assimp/assimp/blob/master/Build.md>，可以根据自己的操作系统进行变动）
    ```shell
    $ cd assimp
    $ cmake CMakeLists.txt 
    $ make -j4
    ```
-   编译完成后在 `bin` 目录中出现 assimp 的库文件，拷贝到全局路径 `/usr/local/lib` 下（理由依然是因为不知道如何让 makefile 包含当前工程下的 lib）

### 其他工具

-   glm 复制到 include 目录下

-   imgui 复制到 include 目下,Makefile 中添加以下命令
    ```mk
    # define the C source files
    SOURCES		:= $(wildcard $(patsubst %,%/*.cpp, $(SOURCEDIRS)))
    SOURCES	    += include/imgui/imgui_impl_glfw.cpp include/imgui/imgui_impl_opengl3.cpp
    SOURCES	    += include/imgui/imgui.cpp include/imgui/imgui_demo.cpp include/imgui/imgui_draw.cpp include/imgui/imgui_widgets.cpp
    ```

### 命令行参数

-   [参考 Makefile 文件](https://github.com/widcardw/start-learning-opengl/blob/dev/Makefile)
    - 其中，链接库的一些参数需要修改
        - glad
            ```mk
            Libraries	:= -lglad
            ```
        - glfw
            ```mk
            Libraries	+= -lglfw.3
            ```
        - assimp
            ```mk
            Libraries	+= -lassimp
            ```

## 示例

### 1. Run 和 Clean

#### 测试代码

```c++
#include <glad/glad.h>
#include <GLFW/glfw3.h>

#include <iostream>

void framebuffer_size_callback(GLFWwindow *window, int width, int height);
void processInput(GLFWwindow *window);

const unsigned int SCR_WIDTH = 800;
const unsigned int SCR_HEIGHT = 600;

int main()
{
	glfwInit();
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
#ifdef __APPLE__
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif

	GLFWwindow *window = glfwCreateWindow(SCR_WIDTH, SCR_HEIGHT, "LearnOpenGL", NULL, NULL);
	if (window == NULL)
	{
		std::cout << "Failed to create GLFW window" << std::endl;
		glfwTerminate();
		return -1;
	}
	glfwMakeContextCurrent(window);
	glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
	{
		std::cout << "Failed to initialize GLAD" << std::endl;
		return -1;
	}

	while (!glfwWindowShouldClose(window))
	{
		processInput(window);
		glfwSwapBuffers(window);
		glfwPollEvents();
	}

	glfwTerminate();
	return 0;
}

void processInput(GLFWwindow *window)
{
	if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
		glfwSetWindowShouldClose(window, true);
}

void framebuffer_size_callback(GLFWwindow *window, int width, int height)
{
	glViewport(0, 0, width, height);
}
```

#### 执行命令 `run` 编译和运行程序

> 注意：不要忘了后面的斜杠，因为程序会读取命令行参数并通过参数来寻找当前文件夹下的 shaders 着色文件

```Bash
make run dir=01_test_glfw/
```

#### 执行命令 `clean` 删除 `out` 和对应文件夹下的 `.o` 文件

> 注意：不要忘了后面的斜杠，原因同上

```Bash
make clean dir=01_test_glfw/
```

### 2. Debug（该部分尚未成功）

-   需要设置调试一个文件 修改 `tasks.json` 下面的条目
    ```json
    {
        "label": "build",
        "type": "shell",
        "group": {
            "kind": "build",
            "isDefault": true
        },
        "osx": {
            "command": "bash",
            "args": ["-c", "make dir=ch_2_light/"]
        }
    }
    ```

-   需要使用 lldb 工具进行 debug
    -   在 VSCode 中安装 Codelldb 插件，未能安装成功需要到官网下载 vxis 之后手动安装插件
    -   该部分暂未测试

### 3. 我的代码

我的代码都在 `mysrc/` 目录下

### 4. 一些问题

-   macOS 上启动 OpenGL 窗口会导致画面生成在右下角，而不能充满整个窗口

    问题已解决，在初始化视窗的时候，将视窗扩展为 2 倍

    ```cpp
    glViewport(0, 0, 2 * WIDTH, 2 * HEIGHT);
    ```

-   macOS 操作系统窗口启动失败

    在主函数中添加声明，具体请参考上面的示例代码
    ```cpp
    #ifdef __APPLE__
        glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    #endif
    ```
