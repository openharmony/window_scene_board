/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * 跨端接口版本号0
 */
export const VERSION_0: number = 0;

/**
 * 跨端接口版本号1
 */
export const VERSION_1: number = 1;

/**
 * RemoteCode 命名空间，用于存放与远程代码相关的类和函数
 */
export namespace RemoteCode {
  /**
   * 成功
   */
  export const SUCCESS: number = 110000;

  /**
   * IDL内部错误
   */
  export const ERR_INNER_IDL: number = 110001;

  /**
   * 断链
   */
  export const ERR_DISCONNECT: number = 110002;

  /**
   * 未知错误
   */
  export const ERR_UNKNOWN: number = 110003;

  /**
   * 接口不存在
   */
  export const ERR_UNIMPL: number = 110004;

  /**
   * 调用者身份不合法
   */
  export const ERR_ILLEGAL_CALLER: number = 110005;

  /**
   * 参数错误
   */
  export const ERR_PARAM: number = 110006;

  /**
   * 系统错误
   */
  export const ERR_OHOS_ERROR: number = 110007;

  /**
   * 调用过频繁
   */
  export const ERR_OVER_FREQUENCY: number = 110008;

  /**
   * 存储空间不足
   */
  export const ERR_LACK_STORAGE: number = 110009;

  /**
   * 主题包格式错误
   */
  export const ERR_ILLEGAL_FORMAT: number = 110010;

  /**
   * 路径校验错误
   */
  export const ERR_ILLEGAL_PATH: number = 110011;

  /**
   * 获取主题信息失败
   */
  export const ERR_THEME_INFO: number = 110012;

  /**
   * 资源拷贝失败
   */
  export const ERR_COPY_FAILED: number = 110013;

  /**
   * 壁纸校验错误
   */
  export const ERR_ILLEGAL_WALLPAPER: number = 110014;

  /**
   * 壁纸类型错误
   */
  export const ERR_WALLPAPER_TYPE: number = 110015;

  /**
   * 壁纸设置失败
   */
  export const ERR_SET_WALLPAPER: number = 110016;

  /**
   * 默认字体不存在
   */
  export const ERR_DEFAULT_FONT: number = 110017;

  /**
   * 默认主题不存在
   */
  export const ERR_DEFAULT_THEME: number = 110018;

  /**
   * 主题id解析错误
   */
  export const ERR_THEME_ID: number = 110019;
}
