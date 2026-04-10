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

import { SCBRecentStyleConstants } from './SCBRecentStyleConstants';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { IconResourceManager } from '@ohos/frameworkwrapper';
const TAG = 'SCBRecentTitleAppIcon';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

/**
 * App icon component for recent sessions.
 */
@Component
export default struct SCBRecentTitleAppIcon {
  @Prop @Watch('updateIcon') bundleName: string = '';
  @Prop @Watch('updateIcon') moduleName: string = '';
  @Prop @Watch('updateIcon') abilityName: string = '';
  @Prop @Watch('updateIcon') appIndex: number = 0;
  @State icon?: ResourceStr | PixelMap = undefined;

  /**
   * The callback of recent sessions app icon.
   *
   * @param {string} image - the value get from ResourceManager
   */
  iconLoadCallback(image: ResourceStr | PixelMap): void {
    log.showInfo(`update app icon of ${this.bundleName}-${this.moduleName} successfully`);
    this.icon = image;
  }

  /**
   * Update the app icon of recent sessions.
   */
  async updateIcon(): Promise<void> {
    log.showInfo(`start update app icon of ${this.bundleName}-${this.moduleName} from cache`);
    let iconImage: string | PixelMap = await IconResourceManager.getInstance().getCombIcon(this.bundleName,
      this.moduleName, this.abilityName, this.appIndex, 'CombIcon_RecentTitleAppIcon');
    if (iconImage && !CheckEmptyUtils.isEmpty(iconImage)) {
      this.iconLoadCallback(iconImage);
    }
  }

  aboutToAppear(): void {
    this.icon = SCBRecentStyleConstants.DEFAULT_APP_ICON_IMAGE;
    this.updateIcon();
  }

  build() {
    Column() {
      Image(this.icon)
        .draggable(false)
        .borderRadius(SCBRecentStyleConstants.RECENT_APP_ICON_BORDER_RADIUS)
        .width(SCBRecentStyleConstants.RECENT_ICON_SIZE)
        .height(SCBRecentStyleConstants.RECENT_ICON_SIZE)
        .id(`${TAG}_Image_${this.bundleName}`)
        .autoResize(false)
        .interpolation(ImageInterpolation.Medium)
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width(SCBRecentStyleConstants.RECENT_ICON_SIZE)
    .height(SCBRecentStyleConstants.RECENT_ICON_SIZE)
  }
}