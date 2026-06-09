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

import { LengthMetrics } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AccessibilityManager, IconResourceManager, ResourceManager } from '@ohos/frameworkwrapper';
import {
  AppItemInfo,
  CommonConstants,
  NoIconAppInfo,
  NoIconAppModel,
  StyleConstants,
} from '@ohos/launchercommon';
import FormStyleConstants from '../../../../default/common/constants/FormStyleConstants';
import {
  FormManagerTitleParam,
  ManagerTitleBuilderInterface } from '../../../interfaces/FormManagerSheetTitleInterface';

const TAG = 'FormManagerTitle';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
// 112 = 两个图标宽度40*2 + 文字两边边距8*2 + 半模态右边的边距16
const TITLE_WIDTH: Length = 'calc(100% - 112vp)';

export class FormManagerTitleWrapper implements ManagerTitleBuilderInterface {
  buildTitle(): WrappedBuilder<FormManagerTitleParam[]> {
    return wrapBuilder(buildFormCenterTitle);
  }
}

@Builder
function buildFormCenterTitle($$: FormManagerTitleParam) {
  FormManagerTitle({
    mAppInfo: $$.appInfo ?? new AppItemInfo(),
  })
}

@Component
export struct FormManagerTitle {
  public mAppInfo: AppItemInfo = new AppItemInfo();
  @State mAppName: string = '';
  @State mAppIcon: string | PixelMap | Resource = '';
  private textId: string = '';

  aboutToAppear(): void {
    let iconResourceManager: IconResourceManager = IconResourceManager.getInstance();
    this.mAppName = this.mAppInfo.applicationName as string;
    if (CheckEmptyUtils.checkStrIsEmpty(this.mAppName)) {
      this.mAppName = iconResourceManager.getCachedIconNameSync(this.mAppInfo.bundleName,
        this.mAppInfo.moduleName, this.mAppInfo.abilityName);
      log.showWarn(`update appName ${this.mAppName}`);
    }
    iconResourceManager.getCombIcon(this.mAppInfo.bundleName,
      this.mAppInfo.moduleName, this.mAppInfo.abilityName).then((icon: image.PixelMap) => {
      this.mAppIcon = icon;
      log.showWarn(`update appIcon is invalid ${!icon}`);
    });
    this.textId = `${TAG}_Text_${this.mAppName}`;
  }

  build() {
    Row() {
      Image(this.mAppIcon)
        .draggable(false)
        .id(`${TAG}_Image_${this.mAppName}`)
        .width(40)
        .height(40)
        .objectFit(ImageFit.Fill)
        .autoResize(false)
        .interpolation(ImageInterpolation.Medium)
        .borderRadius(8)

      Text(this.mAppName)
        .id(this.textId)
        .draggable(false)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize($r('sys.float.ohos_id_text_size_headline8'))
        .fontWeight(FontWeight.Bold)
        .height(FormStyleConstants.FORM_MGR_FORM_NAME_LINE_HEIGHT)
        .maxLines(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
        .margin({ start: LengthMetrics.vp(FormStyleConstants.FORM_MANAGER_TITLE_BAR_MARGIN) })
        .width(TITLE_WIDTH)
        .textAlign(TextAlign.Start)
        .maxFontScale(StyleConstants.FONT_MAX_SCALE_FORM_TEXT)
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
  }
}