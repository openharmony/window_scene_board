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
import { LogDomain, LogHelper, PixelMapUtil } from '@ohos/basicutils';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { GraphicUtils, } from '@ohos/frameworkwrapper';
import {
  GridLayoutItemInfo,
  CommonConstants,
  RdbStoreManager,
  IExecutor
} from '@ohos/launchercommon';
import List from '@ohos.util.List';
import image from '@ohos.multimedia.image';
import Constants from '@ohos/commonconstants/src/main/ets/constants/Constants';

const TAG: string = 'GetAppDisplayInfos';
const SCB_BUNDLE_NAME: string = 'com.ohos.sceneboard';
const SUCCESS_CODE: number = 0;
const FAIL_CODE: number = 1;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 查询应用展示数据
 *
 * @since 2024-10-06
 */
export class GetAppDisplayInfos implements IExecutor {
  async execute(extra?: object): Promise<string> {
    if (!extra) {
      return '';
    }
    let extraStr: string = extra as Object as string;
    log.showInfo(`recv getAppDisplayInfos, extra is ${extraStr}`);
    let requestAppList: List<AppDisplayFilter>;
    try {
      requestAppList = JSON.parse(extraStr);
    } catch (e) {
      log.showError('recv getAppDisplayInfos parse fail');
      return '';
    }
    log.showInfo(`recv getAppDisplayInfos, length is ${requestAppList.length}`);
    let tempGridLayoutItemInfoList: GridLayoutItemInfo[] = await RdbStoreManager.getInstance().queryAllGridLayoutInfo();
    let appDisplayInfos: AppDisplayInfo[] = [];
    for (let i = 0; i < requestAppList.length; i++) {
      let packageName: string = requestAppList[i].packageName;
      log.showInfo(`recv getAppDisplayInfos, packageName is ${packageName}`);
      let gridLayoutInfos: GridLayoutItemInfo[] = tempGridLayoutItemInfoList
        .filter(item => item.typeId === CommonConstants.TYPE_APP && item.bundleName === packageName);
      let appDisplayInfo: AppDisplayInfo = new AppDisplayInfo();
      appDisplayInfo.packageName = packageName;
      if (gridLayoutInfos.length === 0 || CheckEmptyUtils.isEmpty(gridLayoutInfos[0].iconResource)) {
        log.showWarn(`recv getAppDisplayInfos ${packageName} not found`);
        appDisplayInfo.errorCode = FAIL_CODE;
      } else {
        appDisplayInfo.errorCode = SUCCESS_CODE;
        appDisplayInfo.appIcon = await this.getIconAndScale(
          gridLayoutInfos[0].iconResource?.replace(SCB_BUNDLE_NAME, '') ?? '');
        appDisplayInfo.appName = gridLayoutInfos[0].appName ?? '';
      }
      appDisplayInfos.push(appDisplayInfo);
    }
    return JSON.stringify(appDisplayInfos);
  }

  async getIconAndScale(iconResource: string): Promise<string> {
    let imageSource: image.ImageSource | null = null;
    let imagePixelMap: image.PixelMap | null = null;
    try {
      imageSource = image.createImageSource(iconResource);
      log.showInfo(`getIconAndScale iconResource: ${JSON.stringify(iconResource)}`);
      imagePixelMap = await imageSource.createPixelMap();
      if (!imagePixelMap) {
        return '';
      }
      PixelMapUtil.addName(imagePixelMap, `GetAppDisplay_getIconAndScale`);
      const size = imagePixelMap?.getImageInfoSync().size;
      log.showInfo(`getIconAndScale size ${JSON.stringify(size)}`);
      if (!size) {
        log.showError('imagePixelMap get imageInfo error');
        return '';
      }
      let deliverScale = NumberConstants.CONSTANT_NUMBER_NINE / NumberConstants.CONSTANT_NUMBER_TEN;
      if (size.width > deliverScale * Constants.APP_ICON_STANDARD_WIDTH &&
        size.height > deliverScale * Constants.APP_ICON_STANDARD_HEIGHT) {
        const scaleX: number = Constants.APP_ICON_STANDARD_WIDTH / size.width * deliverScale;
        const scaleY: number = Constants.APP_ICON_STANDARD_HEIGHT / size.height * deliverScale;
        await imagePixelMap.scale(scaleX, scaleY);
      }
      let iconStr: string = await GraphicUtils.changePixelToBase64(imagePixelMap);
      log.showInfo(`getIconAndScale iconStr length ${iconStr.length}`);
      if (iconStr.length >= 100 * 1024) {
        log.showError('icon too large not send icon , length = %{public}d', iconStr.length);
        iconStr = '';
      }
      return iconStr;
    } catch (err) {
      log.showError('getIconAndScale message err  %{public}s', err?.message);
      return '';
    } finally {
      imageSource?.release();
      imagePixelMap?.release();
    }
  }
}

interface AppDisplayFilter {
  packageName: string;
}

/**
 * 应用展示信息
 *
 * @since 2024-10-06
 */
export class AppDisplayInfo {
  public packageName: string = '';

  public errorCode: number = -1;

  public appName: string = '';

  public appIcon: string = '';
}
