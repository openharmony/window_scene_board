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

// 不透明白色
export const CONTENT_COLOR_OPAQUE_WHITE: string = '#FFFFFFFF';
// 不透明黑色
export const CONTENT_COLOR_OPAQUE_BLACK: string = '#FF000000';

export const DEFAULT_BG_COLOR: string = '#00FFFFFF';

// 亮色取色值
export const EXTREMELY_LIGHT_COLOR_PICTURE: number = 1;
// 状态栏左padding
export const STATUS_BAR_OUTER_HOME_LEFT_PADDING: number = 20;
// 状态栏布局默认锚点
export const STATUS_BAR_LAYOUT_DEFAULT_ANCHOR: string = '__container__';

// 外屏锁头信息
export const lockIconForOuterHome: CutoutInfo =
  {
    left: 156,
    top: 10,
    width: 16,
    height: 16
  };

/**
 * 挖孔信息
 */
export interface CutoutInfo {
  // vp
  left: number;
  top: number;
  width: number;
  height: number;
}

export const CAPSULE_RIGHT_X = 'CapsuleRightX';