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

import { AppStorageUtil, DataProperty, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { BaseController, CommonData } from '@ohos/controlcentercommon/Index';

const TAG = 'Ctrl.VolumeController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export class VolumeController extends BaseController<VolumeData> {
  private mVolumeData = new VolumeData();

  constructor() {
    super();
    log.showInfo('init VolumeController');
    AppStorageUtil.setOrCreate('VolumeController_lottieDataReady', false, new DataProperty(true, false));
    // 只需要匹配开启的动画资源即可
    this.onStart();
  }

  /**
   * 是否需要加载lottie
   */
  isLoadLottie(): boolean {
    return true;
  }

  getNewLottieOpenName(): string {
    return 'sun.json';
  }

  getData(): CommonData {
    return this.mVolumeData;
  }

  isAvailable(): boolean {
    return true;
  }

  initLottieData(): void {
    this.loadLottieData('sun.json', (value) => {
      this.records.lottieDataOpen = value;
      AppStorageUtil.setOrCreate('VolumeController_lottieDataReady', true, new DataProperty(true, false));
    });
  }
}

export class VolumeData extends CommonData {
  public status: boolean = true;
}

let sVolumeController = SingletonHelper.getInstance(VolumeController, TAG);

export default sVolumeController as VolumeController;