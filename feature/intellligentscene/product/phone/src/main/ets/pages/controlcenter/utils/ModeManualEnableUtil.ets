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

import common from '@ohos.app.ability.common';
import { LogUtil } from '@ohos/scene.common/src/main/ets/utils/LogUtil';
import { TimeConstant } from '@ohos/scene.common/src/main/ets/constant/TimeConstant';
import { SettingsDataUtils } from '@ohos/scene.common/src/main/ets/utils/SettingsDataUtils';
import { SettingsDataKeyConstant } from '@ohos/scene.common/src/main/ets/constant/SettingsDataKeyConstant';
import { AbilityUtils } from '@ohos/scene.common/src/main/ets/utils/AbilityUtils';
import { AbilityContextManager } from '@ohos/scene.common/src/main/ets/ability/AbilityContextManager';
import { ConfigConstant } from '@ohos/scene.common/src/main/ets/constant/ConfigConstant';
import { FactorType, EffectiveSourceType } from '@ohos/scene.common/src/main/ets/model/FactorModel';
import { StringUtil } from '@ohos/scene.common/src/main/ets/utils/StringUtil';
import { ModeUtil } from '@ohos/scene.datamanage/src/main/ets/utils/ModeUtil';
import { ConfigType } from '@ohos/scene.datamanage/src/main/ets/model/base/ConfigType';
import { TimeCondition } from '@ohos/scene.datamanage/src/main/ets/model/TriggerCondition';
import { SysDialogParam } from '@ohos/scene.modeconfig/src/main/ets/model/SysDialogModel';
import { OpenType, SYSTEM_DIALOG_WANT } from '@ohos/scene.modeconfig/src/main/ets/constant/SysDialogConstants';
import TriggerConditionManager from '@ohos/scene.configmanage/src/main/ets/manager/TriggerConditionManager';
import { StateManager } from '@ohos/scene.statemanage/src/main/ets/manager/StateManager';

/* instrument ignore file */
const UN_CHECKED: string = '0';
const CHECKED: string = '1';

const TAG: string = 'ModeManualEnableUtil:';

/**
 * 控制中心/对外Service 工具类
 */
export class ModeManualEnableUtil {
  /**
   * 查询是否勾选不再提醒
   */
  static isNoMoreRemind(): boolean {
    const remindFlag: string =
      SettingsDataUtils.getSecureValue(SettingsDataKeyConstant.INTELLIGENT_SCENE_ENABLE_REMINDER_FLAG, UN_CHECKED);
    LogUtil.showInfo(TAG, `isNoMoreRemind. remindFlag:${remindFlag}`);
    return remindFlag === CHECKED;
  }

  /**
   * 勾选不再提醒
   */
  static setNoMoreRemindFlag(isChecked: boolean): void {
    SettingsDataUtils.setSecureValue(SettingsDataKeyConstant.INTELLIGENT_SCENE_ENABLE_REMINDER_FLAG,
      isChecked ? CHECKED : UN_CHECKED);
  }

  /**
   * 拉起开启模式确认弹框
   */
  static openEnableSysDialog(modeId: string, openType: OpenType): void {
    const context: Context | undefined = AbilityContextManager.getContext();
    if (!context) {
      LogUtil.showError(TAG, 'openEnableSysDialog. context is null');
      return;
    }
    const sysDialogParam: SysDialogParam = {
      modeId: modeId,
      openType: openType,
    };
    LogUtil.showInfo(TAG, `openEnableSysDialog. modeId:${modeId} openType:${openType}`);
    AbilityUtils.openSysDialog(context as common.UIExtensionContext, SYSTEM_DIALOG_WANT, sysDialogParam);
  }

  /**
   * 手动开启模式（立即 / 一小时 / 两小时 / 至今晚）
   * 临时时段：落库 TEMPORARY_TIME_CONDITION + 本地 syncByTimeSchedule（对齐设置深色定时）
   */
  static async manualStartScene(modeId: string, openType: OpenType): Promise<void> {
    LogUtil.showInfo(TAG, `manualStartScene. modeId:${modeId} openType:${openType}`);
    if (openType === OpenType.TURN_ON_NOW) {
      await TriggerConditionManager.clearTemporaryTimeCondition();
      StateManager.getInstance().startScene(modeId, FactorType.USER, EffectiveSourceType.CONTROL_CENTER);
      await StateManager.getInstance().syncByTimeSchedule();
      return;
    }

    const id: string = `${modeId}_${ConfigType.TEMPORARY_TIME_CONDITION}_${ConfigConstant.TEMP_TIME_CONDITION_PREFIX}`;
    let condition: TimeCondition | undefined = undefined;
    switch (openType) {
      case OpenType.TURN_ON_ONE_HOUR:
        condition = ModeUtil.generateConditionByMinute(id + ConfigConstant.TEMP_TIME_CONDITION_ONE_HOUR,
          1 * TimeConstant.ONE_HOUR_MINUTE_UNIT);
        break;
      case OpenType.TURN_ON_TWO_HOUR:
        condition = ModeUtil.generateConditionByMinute(id + ConfigConstant.TEMP_TIME_CONDITION_TWO_HOUR,
          2 * TimeConstant.ONE_HOUR_MINUTE_UNIT);
        break;
      case OpenType.TURN_ON_TONIGHT:
        condition = ModeUtil.generateConditionByEndTime(id + ConfigConstant.TEMP_TIME_CONDITION_TO_NIGHT, '19:00');
        break;
      default:
        LogUtil.showError(TAG, `manualStartScene unsupported openType:${openType}`);
        return;
    }
    if (!condition) {
      LogUtil.showError(TAG, 'manualStartScene condition is empty');
      return;
    }

    const configId: string = await TriggerConditionManager.addTriggerCondition(modeId, condition);
    LogUtil.showInfo(TAG, `manualStartScene temp condition configId:${configId}`);
    if (StringUtil.isEmpty(configId)) {
      LogUtil.showError(TAG, 'manualStartScene save temp condition failed');
      return;
    }
    SettingsDataUtils.setSecureValue(SettingsDataKeyConstant.INTELLIGENT_REFRESH_MODE, `refresh_${configId}`);
    // 显式 AUTO 开启，保证时段结束时 syncByTimeSchedule 可自动关闭
    StateManager.getInstance().startScene(modeId, FactorType.AUTO, EffectiveSourceType.CONTROL_CENTER);
    // 写入生效条件 id，二级页重进时据此回显「开启至 xx:xx」
    StateManager.getInstance().saveEffectiveConfigId(configId);
    await StateManager.getInstance().syncByTimeSchedule();
  }

  /**
   * 手动关闭模式，并清理临时时间条件 / 刷新本地定时器
   */
  static async manualStopScene(modeId: string): Promise<void> {
    LogUtil.showInfo(TAG, `manualStopScene. modeId:${modeId}`);
    await TriggerConditionManager.clearTemporaryTimeCondition();
    StateManager.getInstance().stopScene(modeId, FactorType.USER, EffectiveSourceType.CONTROL_CENTER);
    await StateManager.getInstance().syncByTimeSchedule();
  }
}
