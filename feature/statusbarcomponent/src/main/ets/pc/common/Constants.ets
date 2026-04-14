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


export class Constants {
  public static readonly DEFAULT_PADDING = 4;
  public static readonly WINDOW_POSITION_LEFT_GAP = 8;
  public static readonly DEFAULT_DOCK_GAP = 8;
  public static readonly PC_HOVER_TIPS_TEXT = 'sys.float.ohos_id_text_size_body2';

  public static readonly FIRST_GROUP_BORDER_RADIUS = 8;
  public static readonly FIRST_GROUP_MARGIN_LEFT = 0;

  public static readonly HISEARCH_FONT_SIZE = '15vp';
  public static readonly HISEARCH_SHADOW_X = 0;
  public static readonly HISEARCH_SHADOW_Y = 1;
  public static readonly HISEARCH_SHADOW_BLUR = 2;
  public static readonly HISEARCH_SHADOW_COLOR = '#33000000';
  public static readonly SETTINGS_KEY = 'settings_in_status_bar_type';

  public static readonly POPUP_MIN_TEXT_WIDTH = 64;
  public static readonly PC_TRAY_DROP_FRAME_KEY = 'PcTrayItemDropFrame';

  public static readonly PC_CAPSULE_PLUG_WIDTH = 32;
  public static readonly PC_CAPSULE_PLUG_MARGIN = 2;
  public static readonly NTF_SHADOW_MARGIN = 32;
  public static readonly NTF_PANEL_SPACE = 8;

  public static readonly SYMBOL_ICON_OPACITY = 0.9;
  public static readonly SYMBOL_ICON_SHADOW: Array<ShadowOptions> = [{
    radius: 2,
    color: '#33000000',
    offsetX: 0,
    offsetY: 1
  }, {
    radius: 6,
    color: '#33000000',
    offsetX: 0,
    offsetY: 2
  }];

  public static readonly ROW_GAP = 2;
  public static readonly COLUMN_GAP = 2;

  public static readonly MAX_COLUMNS = 6;
  public static readonly MIN_COLUMNS = 0;
  public static readonly MIN_ROWS = 0;

  public static readonly TRAY_ITEM_WIDTH = 40;
  public static readonly TRAY_ITEM_HEIGHT = 40;
  public static readonly TRAY_ITEM_BG_WH = 40;
  public static readonly TRAY_ITEM_BG_RADIUS = 24;
  public static readonly TRAY_ITEM_MAX_FONT_SIZE = 14;
  public static readonly TRAY_ITEM_MIN_FONT_SIZE = 12;

  public static readonly TEXT_WIDTH = 60;
  public static readonly TEXT_HEIGHT = 19;
  public static readonly TEXT_SIZE = 14;

  public static readonly GRID_MARGIN_TB = 12;
  public static readonly GRID_MARGIN_LR = 12;

  public static readonly TRAY_ITEM_FONT_COLOR = '#FF000000';
  public static readonly TRAY_ITEM_BG_COLOR = '#FFFFFFFF';
  public static readonly TRAY_ITEM_BG_SHADOW_COLOR = '#19000000';
  public static readonly TRAY_ITEM_BG_SHADOW_RADIUS = 8;
  public static readonly TRAY_ITEM_BG_SHADOW_OFFSET_Y = 4;
}