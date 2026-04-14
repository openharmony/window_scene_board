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
 * 外屏主题描述信息
 */
export class SubThemeDescriptionInfo {
  /**
   * 主题id
   */
  public id: string = '';

  /**
   * 主题安装来源
   */
  public origin: string = '';

  /**
   * 主题标题，可以是字符串id
   */
  public title: string = '';

  /**
   * 主题资源简介
   */
  public description: string = '';

  /**
   * 主题包适配的主题引擎API版本
   */
  public apiVersion: string = '';

  /**
   * 主题包规范版本
   */
  public specVersion: string = '';

  /**
   * 主题包版本号，从1开始自增
   */
  public version: string = '';
}