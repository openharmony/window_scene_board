/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
 * 基础常量
 */
export enum BaseConstants {
  /**
   * 数字1
   */
  ONE = 1,

  /**
   * 数字2
   */
  TWO = 2,

  /**
   * 数字3
   */
  THREE = 3,

  /**
   * 数字4
   */
  FOUR = 4,

}

/**
 * 节点渲染类型枚举
 */
export enum BuilderNodeRenderType {
  /**
   * 表示该节点将被显示到屏幕上
   */
  RENDER_TYPE_DISPLAY = 0,

  /**
   * 表示该节点将被导出为纹理
   */
  RENDER_TYPE_TEXTURE = 1,

}


/**
 * 预加载使用场景
 */
export enum UsageScene {
  /**
   * 文件夹展开态中AppBubble预加载场景,0表示未初始化
   */
  FOLDER_APP_BUBBLE = 'FOLDER_APP_BUBBLE'
}