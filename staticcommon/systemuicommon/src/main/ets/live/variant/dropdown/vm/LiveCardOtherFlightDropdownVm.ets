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

import { LayoutStyle } from '../../../../liveview/common/LiveConstants';
import { LiveStyle } from '../../../constants/LiveStyle';
import { LiveCardOtherFlightVm } from '../../../vm/LiveCardOtherFlightVm';

@ObservedV2
export class LiveCardOtherFlightDropdownVm extends LiveCardOtherFlightVm {
  @Computed get layoutTitleColor(): ResourceColor | undefined {
    return this.card?.style === LayoutStyle.SUB_TYPE_BALANCE
      ? $r('app.color.flight_template_title_color')
      : $r('sys.color.ohos_id_color_text_primary');
  }

  @Computed get layoutContentColor(): ResourceColor | undefined {
    return this.card?.style === LayoutStyle.SUB_TYPE_BALANCE
      ? $r('app.color.flight_template_title_color')
      : $r('sys.color.ohos_id_color_text_secondary');
  }

  get layoutSpaceTextColor(): ResourceColor {
    return LiveStyle.FLIGHT_SPACE_TEXT_FONT_COLOR;
  }

  get layoutSpaceTextBorderColor(): ResourceColor {
    return LiveStyle.FLIGHT_SPACE_TEXT_BORDER_COLOR;
  }

  get layoutAdditionalTextColor(): ResourceColor {
    return $r('app.color.flight_template_additional_text_color');
  }
}