/*
 * Copyright (c) 2026 Huawei Device Co., Ltd. All rights reserved.
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

import { CompCtrlParam, ComponentControl } from '@ohos/scene.common/src/main/ets/framework/model/SettingBaseModel';
import { DynamicDataSource } from '@ohos/scene.common/src/main/ets/framework/model/DynamicDataSource';
import {
  ItemResultType,
  ItemType,
  SettingItemModel,
} from '@ohos/scene.common/src/main/ets/framework/model/SettingItemModel';
import { LogUtil } from '@ohos/scene.common/src/main/ets/utils/LogUtil';
import { TimeCondition } from '@ohos/scene.datamanage/src/main/ets/model/TriggerCondition';
import { TimeManager } from '../manager/TimeManager';

/* instrument ignore file */
const TAG: string = 'TimedStatusController';
const TIME_STATUS_ID: string = 'time_status';

/**
 * 定时半模态「开启」开关：对应 TimeCondition.enable，决定该条件是否参与规则下发与到点启停。
 */
export class TimedStatusController implements ComponentControl {
  private dataSource?: DynamicDataSource;
  private timeInfo: TimeCondition = TimeManager.getInstance().getInfo();

  init(compParam: CompCtrlParam): void {
    LogUtil.showInfo(TAG, `init, id: ${compParam.compId}`);
    this.dataSource = compParam.dataSource as DynamicDataSource;
    this.timeInfo = TimeManager.getInstance().getInfo();
    this.dataSource?.pushData(this.getStatusItem());
  }

  destroy(): void {
    LogUtil.showInfo(TAG, 'destroy');
  }

  private getStatusItem(): SettingItemModel {
    return {
      id: TIME_STATUS_ID,
      type: ItemType.ITEM_TYPE_STANDARD,
      title: { content: $r('app.string.enable') },
      result: {
        type: ItemResultType.RESULT_TYPE_TOGGLE,
        result: {
          state: this.timeInfo.enable,
          onChanged: (isOn: boolean): void => {
            LogUtil.showInfo(TAG, `time_status toggle isOn:${isOn}`);
            this.timeInfo.enable = isOn;
          },
        },
      },
    };
  }
}
