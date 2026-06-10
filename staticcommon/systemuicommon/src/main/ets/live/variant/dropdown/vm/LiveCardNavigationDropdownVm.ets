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
import { LiveRichTextModel } from '../../../model/LiveCommonModel';
import { LiveStyle } from '../../../constants/LiveStyle';
import { LiveCardNavigationVm } from '../../../vm/LiveCardNavigationVm';

@ObservedV2
export class LiveCardNavigationDropdownVm extends LiveCardNavigationVm {
  public getContentFontColor(richText: LiveRichTextModel): ResourceColor | undefined {
    return richText.textColor ?? LiveStyle.SYS_TEXT_COLOR_SECONDARY;
  }

  get titleFontColor(): ResourceColor | undefined {
    return $r('sys.color.ohos_id_color_text_primary');
  }

  @Computed get imgColorFilter(): ColorFilter | undefined {
    return this.card.layoutNavigationIconMimeType === 'svg' || this.card.layoutNavigationIconMimeType === 'png' ?
      this.vmInjector.getColorVm().colorFilter : undefined;
  }

  @Computed get navDirsColorFilter(): ColorFilter | undefined {
    return this.card.layoutNavigationIconMimeType === 'svg' || this.card.layoutNavigationIconMimeType === 'png' ?
      this.vmInjector.getColorVm().colorFilter : undefined;
  }
}