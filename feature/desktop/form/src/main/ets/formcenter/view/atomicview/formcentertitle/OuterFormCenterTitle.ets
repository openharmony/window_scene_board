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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EditModeConstants } from '@ohos/launchercommon';
import { EditModeSearchComponent } from '@ohos/launchercommon/src/main/ets/outerdesktop/view/EditModeSearchComponent';
import { EditModeSearchOptions } from '@ohos/launchercommon/src/main/ets/outerdesktop/viewmodel/EditModeSearchComponentEvent';
import { FormCenterTitleParam, CenterTitleBuilderInterface } from '../../../interfaces/FormCenterTitleBuildeInterface';

const TAG = 'OuterFormCenterTitle';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class OuterCenterTitleWrapper implements CenterTitleBuilderInterface {
  buildTitle(): WrappedBuilder<FormCenterTitleParam[]> {
    return wrapBuilder(buildOuterFormCenterTitle);
  }
}

@Builder
export function buildOuterFormCenterTitle($$: FormCenterTitleParam) {
  OuterFormCenterTitle({
    text: $$.text,
    mEditModeSearchOptions: $$.mEditModeSearchOptions,
  })
}

@Component
export struct OuterFormCenterTitle {
  public text?: string | Resource;
  public mEditModeSearchOptions?: EditModeSearchOptions;

  build() {
    Column() {
      EditModeSearchComponent({
        titleName: this.text,
        mEditModeSearchOptions: this.mEditModeSearchOptions,
        isForm: true
      })
    }
    .margin({ top: EditModeConstants.OUTER_SEARCH_COMPONENT_TOP_MARGIN })
    .width(EditModeConstants.OUTER_SEARCH_COMPONENT_WIDTH)
    .height(EditModeConstants.OUTER_SEARCH_COMPONENT_HEIGHT)
    .justifyContent(FlexAlign.Center)
  }
}