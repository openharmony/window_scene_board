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

import { GlassLayoutSize } from '../../common/constants/GlassLayoutConstants';

@Observed
export class GlassBannerContentStyle {
  /**
   * banner整体竖向位移，vp
   * 横幅场景
   */
  public bannerTranY: number = 0;
  /**
   * banner整体横向位移，vp
   * 横幅场景
   */
  public bannerTranX: number = 0;
}

export class GlassBannerLayoutStyle extends GlassLayoutSize {
  public static readonly BANNER_BLUR: number = 217.46;
  public static readonly NTF_HEAD_ICON_SIZE: string = '31.11px';
  public static readonly BORDER_WIDTH: string = '1px';
  public static readonly BORDER_RADIUS: string = '32px';
  public static readonly LIVE_CONTENT_WIDTH: string = '584px';
  public static readonly BANNER_FOLDS_CONTENT_WIDTH: string = '970px';
  public static readonly BANNER_EXPAND_CONTENT_WIDTH: string = '944px';
  public static readonly CARD_LARGE_ICON_RADIUS: Length = '32';
  public static readonly LEFT_LARGE_ICON_RADIUS: Length = '8vp';
  public static readonly FONT_FAMILY_SANS_SC: string = 'HarmonyOS Sans SC';
  public static readonly FONT_FAMILY_ohos_BOLD: string = 'OpenHarmony黑体';
  public static readonly BANNER_PADDING: Padding = {
    left: '24px',
    right: '24px',
    top: '24px',
    bottom: '24px'
  };
  public static readonly PHONE_HINT_PADDING: Padding = {
    left: '26px',
    right: '24px',
    top: '32px',
    bottom: '32px'
  };
  public static readonly SINGLE_BANNER_PADDING: Padding = { top: '30px' };
  public static readonly OVERLAY_ICON_MARGIN: Margin = { right: '-5px', bottom: '-5.5px' };
  public static readonly NTF_ICON_MARGIN: Margin = { right: '24px' };
  public static readonly LIVE_CONTENT_TEXT_MARGIN: Margin = { bottom: '10px' };
  public static readonly LIVE_CONTENT_BUTTON_MARGIN: Margin = { right: '178px' };
  public static readonly LIVE_BUTTONS_MARGIN: Margin = { left: '24px' };
  public static readonly LIVE_OVERLAY_ICON_MARGIN: Margin = { right: '24px' };
  public static readonly NORMAL_OVERLAY_ICON_MARGIN: Margin = { right: '-12.56px', bottom: '-10.56px' };
  public static readonly NORMAL_EXPAND_TITLE_MARGIN: Margin = { top: '3px' };
  public static readonly NORMAL_EXPAND_CONTENT_MARGIN: Margin = { top: '9px' };
  public static readonly NORMAL_EXPAND_COLUMN_MARGIN: Margin = { top: '47px' };
  public static readonly NORMAL_HEAD_PORTRAIT_MARGIN: Margin = { right: '28px' };
  public static readonly NORMAL_APPICON_MARGIN: Margin = { right: '22px' };
  public static readonly NORMAL_CONTENT_MARGIN: Margin = { left: '16px' };
  public static readonly ACTION_BUTTON_MARGIN: Margin = { right: '32px' };

  // 来电横幅字段间距
  public static readonly INCOME_CALL_TEXT_SPACE:string = '10px';
}