/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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
import { CommonConstants } from '@ohos/launchercommon';

export class RecentStyle {

  private static readonly DPI_RATIO = 1.0;
  private static readonly RECENT_DELETE_IMAGE_RADIUS = 24;
  private static readonly RECENT_DELETE_IMAGE_RADIUS_OUTER = 18;
  private static readonly RECENT_DELETE_IMAGE_COLUMN_RADIUS = 48;
  private static readonly RECENT_DELETE_IMAGE_COLUMN_RADIUS_OUTER = 36;
  private static readonly RECENT_DELETE_IMAGE_MARGIN_RADIUS = 20;
  private static readonly SINGLE_LIST_LAYOUT_MARGIN_RADIUS = 24;
  private static readonly SINGLE_LIST_LAYOUT_BOTTOM_SPACE_RADIUS = 37.67;

  public static readonly RECENT_DELETE_IMAGE_SIZE = RecentStyle.RECENT_DELETE_IMAGE_RADIUS * RecentStyle.DPI_RATIO;
  public static readonly RECENT_DELETE_IMAGE_SIZE_OUTER =
    RecentStyle.RECENT_DELETE_IMAGE_RADIUS_OUTER * RecentStyle.DPI_RATIO;
  public static readonly RECENT_DELETE_IMAGE_COLUMN_SIZE = RecentStyle.RECENT_DELETE_IMAGE_COLUMN_RADIUS *
    RecentStyle.DPI_RATIO;
  public static readonly RECENT_DELETE_IMAGE_COLUMN_SIZE_OUTER = RecentStyle.RECENT_DELETE_IMAGE_COLUMN_RADIUS_OUTER *
    RecentStyle.DPI_RATIO;
  public static readonly RECENT_DELETE_IMAGE_MARGIN_SIZE = RecentStyle.RECENT_DELETE_IMAGE_MARGIN_RADIUS *
    RecentStyle.DPI_RATIO;
  public static readonly SINGLE_LIST_LAYOUT_MARGIN = RecentStyle.SINGLE_LIST_LAYOUT_MARGIN_RADIUS *
    RecentStyle.DPI_RATIO;

  public static readonly DEFAULT_DELETE_IMAGE_OPACITY = 0.2;
  public static readonly DEFAULT_DELETE_COLOR = '#000000';
  public static readonly DEFAULT_DELETE_IMAGE_FULL = '/common/pics/ic_public_delete_full.svg';
  public static readonly FULL_DELETE_IMAGE_SCALE = 0.85;
  public static readonly RECENT_DELETE_SYMBOL_SIZE = '24vp';
  public static readonly RECENT_DELETE_SYMBOL_SIZE_OUTER = '18vp';
  public static readonly RECENT_DELETE_SYMBOL_COLOR = '#FFFFFF';
  public static readonly DEFAULT_DELETE_SYMBOL_OPACITY = 0.86;
  public static readonly RECENT_DELETE_SYMBOL_COLUMN_RADIUS = '48vp';
  public static readonly RECENT_DELETE_SYMBOL_COLUMN_RADIUS_OUTER = '36vp';
  public static readonly RECENT_DELETE_SYMBOL_BORDER_RADIUS = 96;
  public static readonly RECENT_DELETE_SYMBOL_BORDER_RADIUS_OUTER = 36;
  public static readonly FAKER_INTO_CARD_RATIO = 0.75;
  public static readonly SINGLE_LIST_LAYOUT_BOTTOM_SPACE = RecentStyle.SINGLE_LIST_LAYOUT_BOTTOM_SPACE_RADIUS *
    RecentStyle.DPI_RATIO;
  public static readonly VERTICAL_RECENT_TILE_BOTTOM_MARGIN = 10;
  public static readonly START_SCENE_SCALE_PERCENT_MULTI_ROW = 0.95;
  public static readonly START_SCENE_ALPHA_MULTI_ROW = 0;
  public static readonly START_SCENE_TRANSLATE_OFFSET_MULTI_ROW = 10;
}