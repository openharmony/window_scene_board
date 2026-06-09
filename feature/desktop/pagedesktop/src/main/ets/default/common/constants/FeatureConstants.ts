/**
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
import { curves } from '@kit.ArkUI';

export default class FeatureConstants {
  public static readonly FEATURE_NAME = 'pageDesktop';

  public static readonly HOVER_BACKGROUND_COLOR = 0x0D0A59F7;
  public static readonly PRESS_BACKGROUND_COLOR = '#25073AA2';
  public static readonly DEFAULT_BACKGROUND_COLOR = 'rgba(0,0,0,0)';
  public static readonly COLUMN_GAP = 8;
  public static readonly ROW_GAP = 8;
  public static readonly BORDER_COLOR = 0x33FFFFFF;
  public static readonly BORDER_WIDTH = 1;
  public static readonly BORDER_RADIUS = 8;
  public static readonly DEFAULT_SUPPORT_INDICATOR  = false;
  public static readonly FORM_UNDO_LINEAR_GRADIENT_ANGLE = 180;
  public static readonly FORM_UNDO_LINEAR_GRADIENT_START_COLOR = 'rgba(0, 0, 0, 0.5)';
  public static readonly FORM_UNDO_LINEAR_GRADIENT_START_WEIGHT = 0.0;
  public static readonly FORM_UNDO_LINEAR_GRADIENT_END_COLOR = 'rgba(0, 0, 0, 0)';
  public static readonly FORM_UNDO_LINEAR_GRADIENT_END_WEIGHT = 1.0;
  public static readonly FORM_UNDO_BUTTON_HEIGHT = 28;
  public static readonly FORM_UNDO_BUTTON_IMAGE_HEIGHT = 16;
  public static readonly FORM_UNDO_BUTTON_FONT_SIZE = 14;
  public static readonly FORM_UNDO_BUTTON_BORDER_RADIUS = 14;
  public static readonly FORM_UNDO_BUTTON_TEXT_MARGIN = 10;
  public static readonly FORM_UNDO_BUTTON_PADDING = 10;
  public static readonly FORM_UNDO_BUTTON_MARGIN = 12;
  public static readonly FORM_UNDO_BACKGROUND_COLOR = '#E84026';
  public static readonly FORM_UNDO_POSITION = 0;
  public static readonly FORM_UNDO_BUTTON_SHADOW_RADIUS = 100;
  public static readonly FORM_UNDO_BUTTON_SHADOW_COLOR = 'rgba(0, 0, 0, 0.05)';
  public static readonly FORM_UNDO_BUTTON_SHADOW_OFFSET_Y = 5;
  public static readonly FORM_UNDO_BUTTON_BG_EFFECT_RADIUS = 60;
  public static readonly FORM_UNDO_BUTTON_BG_EFFECT_NORMAL_SATURATION = 2;
  public static readonly FORM_UNDO_BUTTON_BG_EFFECT_LIGHT_SATURATION = 0.5;
  // 背景色20%不透明度
  public static readonly FORM_UNDO_BUTTON_BG_COLOR_OPACITY = '33';

  public static readonly CALCULATE_TWO = 2;
  public static readonly CALCULATE_ONE_POINT_FIVE = 1.5;
  public static readonly INDEX_NINE = 9;

  public static readonly BUNDLE_NAME_CREATE_FOLDER = 'createFolder';
  public static readonly BUNDLE_NAME_REFRESH = 'refresh';
  public static readonly BUNDLE_NAME_PASTE = 'paste';
  public static readonly BUNDLE_NAME_CREATE_INDIVIDUATION = 'individuation';
  public static readonly BUNDLE_NAME_FORM_CENTER = 'formCenter';

  public static readonly DEFAULT_ITEM_ALPHA: number = 1.0;
  public static readonly CUT_ITEM_ALPHA: number = 0.4;

  public static readonly DOUBLE_CLICK_COUNT = 2;
  public static readonly DOUBLE_CLICK_INVALID_DURATION = 300;
  public static readonly FORM_SCALE_IN_MANAGE_VIEW_2X4 = 0.8;
  public static readonly FORM_SCALE_IN_MANAGE_VIEW_4X4 = 0.7;

  // 4*4大卡片落位堆叠动效曲线
  public static readonly LARGE_CARD_DROP_CURVES = curves.springMotion(0.516, 0.99, 0);
  public static readonly MIN_NEED_SORT_LEN = 2;

  // 磁吸键盘状态：无键盘/有键盘B面/有键盘C面
  public static readonly NO_KEYBOARD = -1;
  public static readonly KEYBOARD_PAGE_B = 0;
  public static readonly KEYBOARD_PAGE_C = 1;
}