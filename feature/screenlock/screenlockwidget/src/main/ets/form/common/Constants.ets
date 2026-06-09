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

export default class Constants {
  /**
   * 外屏卡片面板宽度
   */
  public static readonly OUTER_PANEL_WIDTH: number = 190.67;
  /**
   * 外屏卡片组件高度
   */
  public static readonly OUTER_SCREEN_FORM_COMPONENT_HEIGHT: number = 48;
  /**
   * 外屏卡片显隐动效时长
   */
  public static readonly OUTER_SCREEN_CARD_OPACITY_DURATION: number = 150;
  /**
   * 外屏卡片显隐动效延迟
   */
  public static readonly OUTER_SCREEN_CARD_OPACITY_DELAY: number = 100;
  /**
   * 外屏卡片尺寸
   */
  public static readonly OUTER_SCREEN_SINGLE_CARD_SIZE: number = 48;
  /**
   * 外屏卡片间隔
   */
  public static readonly OUTER_SCREEN_GRID_GAP: number = 31.56;
  /**
   * 外屏卡片半径
   */
  public static readonly OUTER_SCREEN_FORM_COMPONENT_RADIUS: number = 24;
  /**
   * 外屏卡片容器上下内边距
   */
  public static readonly OUTER_SCREEN_GRID_PADDING_HEIGHT: number = 20;
  /**
   * 外屏卡片容器左右内边距
   */
  public static readonly OUTER_SCREEN_GRID_PADDING_WIDTH: number = 31.56;
  /**
   * 外屏卡片容器高度
   */
  public static readonly OUTER_SCREEN_GRID_HEIGHT: number = 88;
  /**
   * 外屏卡片背板缩放
   */
  public static readonly OUTER_SCREEN_CARD_PRESS_SCALE: number = 1.15;
  /**
   * 外屏卡片图标缩放
   */
  public static readonly OUTER_SCREEN_CARD_ICON_PRESS_SCALE: number = 1.1;
  /**
   * default zoom ratio
   */
  public static readonly DEFAULT_ZOOM_RATIO: number = 1.0;
  /**
   * milliseconds to seconds
   */
  public static readonly MILLISECOND_TO_SECOND: number = 1000;

  public static readonly FORM_LISTENER: string = 'form_listener';

  public static readonly FORM_MANAGER_PANEL_SCALE_90 = 0.90;

  public static readonly FORM_MANAGER_PANEL_SCALE_95 = 0.95;
  /**
   * 锁屏编辑拖拽卡片移动
   */
  public static readonly SCREEN_LOCK_EDIT_CARD_DRAG: string = 'SCREEN_LOCK_EDIT_CARD_DRAG';
}

export interface SlGreetStateListener {
  onGreetShow(isAni?: boolean): void;

  onGreetHide(isAni?: boolean): void;
}