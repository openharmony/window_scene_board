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

import { LogHelper, LogDomain, CheckEmptyUtils } from '@ohos/basicutils';
import { IconResourceManager } from '@ohos/frameworkwrapper';
import {
  AppItemInfo,
  CardItemInfo,
  launcherAbilityManager,
  PageDesktopModel
} from '@ohos/launchercommon';
import FormStyleConstants from '../constants/FormStyleConstants';
import ServiceFormManager from '../../manager/ServiceFormManager';
import { NoIconAppInfo, NoIconAppModel } from '@ohos/launchercommon/src/main/ets/model/NoIconAppModel';

const TAG = 'FormManagerTitleBar';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export default struct FormManagerTitleBar {
  @Prop @Watch('updateIcon') appInfo: CardItemInfo = new CardItemInfo();
  @Prop appName: string = '';
  @State icon: string | PixelMap = '';
  private nameLines: number = 0;

  aboutToAppear() {
    this.nameLines = PageDesktopModel.getInstance().getPageDesktopStyleConfig().mNameLines;
    if (NoIconAppModel.getInstance().checkIfBundleIsNoIconApp(this.appInfo?.bundleName)) {
      let appInfo: NoIconAppInfo = NoIconAppModel.getInstance().updateNoIconAppInfo(this.appInfo.bundleName);
      this.appName = appInfo.label;
    }
    this.updateIcon();
  }

  private async updateIcon(): Promise<void> {
    if (CheckEmptyUtils.isEmpty(this.appInfo)) {
      log.showError('appInfo is empty');
      return;
    }
    log.showInfo('update bundleName=%{public}s, moduleName=%{public}s',
      this.appInfo.bundleName, this.appInfo.moduleName);
    if (this.appInfo.bundleName && this.appInfo.moduleName) {
      let appItemInfo: AppItemInfo;
      let appIconId: number | undefined = await launcherAbilityManager.getAppIconId(this.appInfo.bundleName);
      if (CheckEmptyUtils.isEmpty(appIconId)) {
        let appList = await ServiceFormManager.getInstance().getServiceFormAppList();
        appItemInfo = appList.find(item => {
          return (item.bundleName === this.appInfo.bundleName && item.moduleName === this.appInfo.moduleName);
        }) as AppItemInfo;
      } else {
        appItemInfo = new AppItemInfo();
        appItemInfo.appIconId = appIconId as number;
      }
      IconResourceManager.getInstance()
        .getCombIcon(this.appInfo.bundleName, this.appInfo.moduleName, this.appInfo.abilityName)
        .then((iconResource: string | PixelMap) => this.iconLoadCallback(iconResource));
    }
  }

  private iconLoadCallback(image: string | PixelMap): void {
    log.showInfo(`icon load callback: ${image}`);
    this.icon = image;
    if (!this.icon) {
      this.icon = FormStyleConstants.DEFAULT_ICON_IMAGE;
    }
  }

  build() {
    Row() {
      Image(this.icon)
        .draggable(false)
        .id(`${TAG}_Image_${this.appInfo?.applicationName}`)
        .width(FormStyleConstants.FORM_MANAGER_APP_ICON_SIZE)
        .height(FormStyleConstants.FORM_MANAGER_APP_ICON_SIZE)
        .objectFit(ImageFit.Fill)
        .autoResize(false)
        .interpolation(ImageInterpolation.Medium)
        .borderRadius(8)
        .margin({
          left: FormStyleConstants.FORM_MANAGER_TITLE_MARGIN
        })

      Text(this.appName)
        .id(`${TAG}_Text_${this.appName}`)
        .draggable(false)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize($r('sys.float.ohos_id_text_size_headline8'))
        .fontWeight(FontWeight.Medium)
        .lineHeight(FormStyleConstants.FORM_MGR_FORM_NAME_LINE_HEIGHT)
        .maxLines(this.nameLines)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
        .margin({
          left: FormStyleConstants.FORM_MANAGER_TITLE_BAR_MARGIN
        })
        .textAlign(TextAlign.Start)
    }
    .height(FormStyleConstants.FORM_MANAGER_APP_ICON_SIZE)
    .width(FormStyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
    .justifyContent(FlexAlign.Start)
  }
}