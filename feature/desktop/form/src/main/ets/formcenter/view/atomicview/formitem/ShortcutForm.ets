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

import { image } from '@kit.ImageKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CardItemInfo, AppItemInfo, CommonConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  ShortcutViewModel,
} from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/ShortcutViewModel';
import {
  FormItemBuilderInterface,
  FormItemParam,
} from '../../../interfaces/FormItemBuilderInterface';
import { FormViewModel } from '../../../../default/viewmodel/FormViewModel';

const TAG: string = 'ShortcutForm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export default class ShortcutForm implements FormItemBuilderInterface {
  public buildView(): WrappedBuilder<FormItemParam[]> {
    return wrapBuilder(buildFormItem);
  }
}

@Builder
function buildFormItem(config: FormItemParam) {
  ShortcutFormItem({
    formItem: config.formUIConfig.formItem,
    idIndex: config.formUIConfig.index,
  })
}

@Component
struct ShortcutFormItem {
  public formItem: CardItemInfo = new CardItemInfo();
  public idIndex: number = 0;
  private mFormViewModel: FormViewModel = FormViewModel.getInstance();
  @State iconSize: number = 0;
  @State iconRadius: number = 0;
  @State shortCutImage: string | image.PixelMap = '';

  async aboutToAppear(): Promise<void> {
    this.iconSize = this.mFormViewModel.getShortcutFormSize();
    this.iconRadius = this.mFormViewModel.getShortcutFormRadius();
    let appItem: AppItemInfo = new AppItemInfo();
    appItem.bundleName = this.formItem.shortcutInfo?.bundleName ?? '';
    appItem.appIconId = this.formItem.shortcutInfo?.iconId ?? 0;
    appItem.moduleName = this.formItem.shortcutInfo?.moduleName ?? '';
    appItem.appIndex = this.formItem.shortcutInfo?.appIndex ?? 0;
    appItem.shortcutId = this.formItem.shortcutInfo?.id ?? '';
    this.shortCutImage = await ShortcutViewModel.getInstance().getShortcutImageAsync(appItem);
  }

  build() {
    Image(this.shortCutImage)
      .draggable(false)
      .id(`ShortcutForm_${this.formItem.bundleName}_${this.formItem.shortcutInfo?.id}`)
      .interpolation(ImageInterpolation.Medium)
      .borderRadius(this.iconRadius)
      .height(this.iconSize)
      .width(this.iconSize)
      .autoResize(false)
      .shadow({
        radius: $r('app.float.normal_form_manager_radius'),
        color: $r('app.color.normal_form_manager_shadow_color'),
        offsetY: $r('app.float.normal_form_manager_offset')
      })
  }
}