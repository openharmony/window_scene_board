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
 * 状态栏插件动效参数控制类
 */
import type image from '@ohos.multimedia.image';

export class PluginAnimatorInfo {
  /**
   * 右侧视图位移距离
   */
  rightItemTranslateNum: number = 0;

  /**
   * 胶囊是否在展示中
   */
  isCapsuleShowing: boolean = false;
}

/**
 * 状态栏实况胶囊信息，包含位移、长度等，用于和实况卡片动效交互
 */
export class LiveViewCapsuleInfo {
  /**
   * 横向位移
   */
  globalPositionX: number = 0;

  /**
   * 纵向位移
   */
  globalPositionY: number = 0;

  /**
   * 实例胶囊宽度
   */
  capsuleWidth: number = 0;

  /**
   * 实况胶囊高度
   */
  capsuleHeight: number = 0;

  /**
   * 实况胶囊当前缩放比例
   */
  capsuleScale: number = 1;

  /**
   * 实况胶囊圆角
   */
  capsuleBorderRadius: number = 0;

  /**
   * 应用图标
   */
  icon?: image.PixelMap;

  /**
   * 背景颜色
   */
  backGroundColor: string | undefined = '';
}