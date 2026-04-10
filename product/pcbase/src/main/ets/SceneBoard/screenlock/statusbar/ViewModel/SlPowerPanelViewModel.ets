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

import {
  LogDomain,
  LogHelper,
  SingletonHelper,
} from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { PowerMenuType } from '../PowerViewModel';
import Constants from '../../common/Constants';

const TAG = 'SCBScreenLock-SlPowerPanelModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class SlPowerPanelListInfo {
  public powerType: PowerMenuType | undefined = undefined;
  public textContent: Resource | undefined = undefined;
  public dialogMsg?: Resource | undefined = undefined;
  public notInvolve?: boolean = false;
}

export class SlPowerPanelModel {
  private isPCMode: boolean = DeviceHelper.is2In1DevicePcType();
  public powerPanelList: SlPowerPanelListInfo[] = [];
  public functionListLength: number = 0;
  public slPowerPanelHeight: number = 0;
  public slPowerMenuListHeight: number = 0;

  constructor() {
    this.getPowerPanelListMap();
  }

  private getPowerPanelListMap(): void {
    const funListMap: SlPowerPanelListInfo[] = [
      {
        powerType: PowerMenuType.DORMANT,
        textContent: $r('app.string.sleep'),
        notInvolve: this.isPCMode
      },
      {
        powerType: PowerMenuType.RESTART,
        dialogMsg: $r('app.string.restart_dialog_message'),
        textContent: $r('app.string.reboot_device')
      },
      {
        powerType: PowerMenuType.POWER_OFF,
        dialogMsg: $r('app.string.power_dialog_message'),
        textContent: $r('app.string.shutdown_device')
      }
    ];
    funListMap.forEach((item: SlPowerPanelListInfo) => {
      if (!item.notInvolve) {
        this.powerPanelList.push(item);
      }
    })
    this.functionListLength = this.powerPanelList.length;
    this.slPowerPanelHeight = this.functionListLength * Constants.POWER_PANEL_ITEM_HEIGHT;
    this.slPowerMenuListHeight = this.functionListLength * Constants.POWER_MENU_ITEM_HEIGHT +
    this.functionListLength + 1;
  }
}

let slPowerPanelModel = SingletonHelper.getInstance(SlPowerPanelModel, TAG);

export default slPowerPanelModel as SlPowerPanelModel;