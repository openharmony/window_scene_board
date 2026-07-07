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

import { LengthMetrics } from '@kit.ArkUI'
import FormStyleConstants from '../../default/common/constants/FormStyleConstants';

export class FormCenterTitleStyle {
  public titlePadding: Padding | Length | LocalizedPadding = {
    start: LengthMetrics.vp(16),
  }
  public alignItems: VerticalAlign = VerticalAlign.Center;
  public textLineHeight: Length = FormStyleConstants.FORM_MGR_FORM_NAME_LINE_HEIGHT;
  public fontSize: number | string | Resource = $r('sys.float.ohos_id_text_size_headline8');
  public titleHeight: Length = FormStyleConstants.FORM_CENTER_TITLE_HEIGHT;
  public closeButtonSize: number = 40;
  public closeButtonIconSize: number = 18;
  public closeButtonMarginEnd: number = 16;
  public closeButtonBgColor: ResourceColor = $r('app.color.media_control_default_img_bgc');
  public closeButtonIconColor: ResourceColor = $r('sys.color.ohos_id_color_primary');

  adaptPC() {
    this.titlePadding = {
      start: LengthMetrics.vp(24),
      top: LengthMetrics.vp(23),
    }
    this.alignItems = VerticalAlign.Top;
  }
}

