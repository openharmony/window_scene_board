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

export enum SceneType {
  GALLERY,
  EDITOR,
  ICON_EDIT,
  WALLPAPER_EDIT,
  LOCK_SCREEN_EDIT,
  EDITOR_TO_LOCK_SCREEN_EDIT,
  LOCK_SCREEN_EDIT_TO_EDITOR,
  GALLERY_TO_EDITOR,
  ADD_SCREEN_FORM,
  SCREEN_FORM_DETAIL,
  SCREEN_FORM_DETAIL_TO_SCREEN_FORM
}

/**
 * 锁屏卡片常量
 */
export default class ScreenLockFormConstants {
  public static readonly THEME_EDITOR_TIP_DIALOG: string = 'THEME_EDITOR_TIP';
}

/**
 * 主题场景，值与主题包规范的路劲限定符对应
 */
export enum ThemeScene {
  NONE = 'unknown',
  BASE = 'base', // 直板机、大折叠外屏、GL产品F态、平板产品竖屏
  LAND = 'land', // 存放平板产品横屏壁纸资源, 艺术构图生成的时钟位置等
  UNFOLDED = 'unfolded', // 大折叠展开态（竖屏）、GL产品M态（竖屏）
  LAND_UNFOLDED = 'unfolded-land', // 大折叠展开态（横屏）、GL产品M态（横屏）
  UNFOLDED2 = 'unfolded2', // GL产品G态（竖屏）——保留值
  LAND_UNFOLDED2 = 'unfolded2-land', // GL产品G态（横屏）——保留值
  SMALL_FOLD = 'small-fold' // vde小外屏
}