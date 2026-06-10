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

import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SpecialModeViewModel as SpecialModeBaseViewModel } from '../refactor/specialmode/viewmodel/SpecialModeViewModel';
import {
  LostModeConstants as LostModeBaseConstants,
  LostModeViewData as LostModeBaseViewData,
  SpecialModeViewData as SpecialModeBaseViewData } from '../refactor/specialmode/model/SpecialModeViewData';
import { SettingsDBMonitor } from '@ohos/screenlockcomponent/src/main/ets/monitor/SettingsDBMonitor';


const TAG = 'ScreenLock-SpecialModePCViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class SpecialModeViewModel extends SpecialModeBaseViewModel {

  protected static specialModeViewModel: SpecialModeViewModel;
  public specialViewData: SpecialModeViewData;

  constructor(data: SpecialModeViewData) {
    super(data);
    this.specialViewData = data;
  }

  public static getInstance(data?: SpecialModeViewData): SpecialModeViewModel {
    if (!SpecialModeViewModel.specialModeViewModel) {
      data = data ?? new SpecialModeViewData();
      SpecialModeViewModel.specialModeViewModel = new SpecialModeViewModel(data);
    }
    return SpecialModeViewModel.specialModeViewModel;
  }

  initLostModeData(): void {
    log.showInfo('SpecialModeViewModel initData=' + this.specialViewData);
    if (this.specialViewData == undefined) {
      return;
    }
    let lockStatusContact: string = sSettingsUtil.getSecureValue(LostModeConstants.LOCK_CONTACT_KEY.split('|')[0],
      LostModeConstants.LOCK_INFO_DEFAULT_VALUE);
    this.specialViewData.lastModeData.lostModeContact = lockStatusContact;
    SettingsDBMonitor.getInstance().subscribe(LostModeConstants.LOCK_CONTACT_KEY, () => this.onLostModeDataChange());
    super.initLostModeData();
  }

  onLostModeDataChange(): void {
    if (this.specialViewData == undefined) {
      return;
    }
    let lockStatusContact: string = sSettingsUtil.getSecureValue(LostModeConstants.LOCK_CONTACT_KEY.split('|')[0],
      LostModeConstants.LOCK_INFO_DEFAULT_VALUE);
    this.specialViewData.lastModeData.lostModeContact = lockStatusContact;
    super.onLostModeDataChange();
  }
}

@Observed
export class SpecialModeViewData extends SpecialModeBaseViewData {
  public lastModeData: LostModeViewData = new LostModeViewData();
}


@Observed
export class LostModeViewData extends LostModeBaseViewData {
  /**
   * 丢失模式联系方式
   */
  public lostModeContact: string | undefined = undefined;
}

export class LostModeConstants extends LostModeBaseConstants {
  public static LOCK_STATE_KEY = 'find_device_remote_lock|SECURE_DB';
  public static LOCK_INFO_KEY = 'find_device_remote_lock_info|SECURE_DB';
  public static LOCK_CONTACT_KEY = 'find_device_remote_lock_contact|SECURE_DB';
  public static LOCK_INFO_DEFAULT_VALUE = '';
  public static LOCK_STATE_DEFAULT_VALUE = '0';
  public static LOCK_STATE_OPEN_VALUE = '1';
}