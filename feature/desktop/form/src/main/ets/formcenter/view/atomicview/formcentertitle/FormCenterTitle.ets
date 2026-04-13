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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { StyleConstants } from '@ohos/launchercommon';
import { FormCenterTitleParam, CenterTitleBuilderInterface } from '../../../interfaces/FormCenterTitleBuildeInterface';
import { FormCenterTitleStyle } from '../../../viewstyles/FormCenterTitleStyle';

const TAG = 'FormCenterTitle';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormCenterTitleWrapper implements CenterTitleBuilderInterface {
  buildTitle(): WrappedBuilder<FormCenterTitleParam[]> {
    return wrapBuilder(buildFormCenterTitle);
  }
}

@Builder
function buildFormCenterTitle($$: FormCenterTitleParam) {
  FormCenterTitle({
    style: $$.style ?? new FormCenterTitleStyle(),
    text: $$.text,
  })
}

@Component
export struct FormCenterTitle {
  public style: FormCenterTitleStyle = new FormCenterTitleStyle();
  public text: string | Resource = '';

  build() {
    Row() {
      Text(this.text)
        .id(`${TAG}_Title_Text`)
        .draggable(false)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize(this.style.fontSize)
        .fontWeight(FontWeight.Bold)
        .height(this.style.textLineHeight)
        .maxLines(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
        .textAlign(TextAlign.Start)
        .maxFontScale(StyleConstants.FONT_MAX_SCALE_FORM_TEXT)
    }
    .padding(this.style.titlePadding)
    .width('100%')
    .height(this.style.titleHeight)
    .alignItems(this.style.alignItems)
    .justifyContent(FlexAlign.Start)
  }
}