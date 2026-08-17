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

import { LogUtil } from '@ohos/scene.common/src/main/ets/utils/LogUtil';
import { EventBus } from '@ohos/scene.common/src/main/ets/framework/common/EventBus';
import { EventBusNameConstant } from '@ohos/scene.common/src/main/ets/constant/EventBusNameConstant';
import { ModalSheetKey } from '@ohos/scene.common/src/main/ets/constant/EntryKeyConsts';
import { PADDING_16 } from '@ohos/scene.common/src/main/ets/framework/common/StyleConstant';
import { HOME_PAGE_ID, HOME_MODAL_GROUP_ID } from '@ohos/scene.modeconfig/src/main/ets/constant/HomeCompIdConstant';
import { CompCtrlParam, ComponentControl } from '@ohos/scene.common/src/main/ets/framework/model/SettingBaseModel';
import { OrderedDataSource } from '@ohos/scene.common/src/main/ets/framework/model/OrderedDataSource';
import {
  ComparableSettingItemModel,
  ItemDetailType,
  ItemResultType,
  ItemType,
  SettingIconType,
  SettingItemModel,
  SettingTextType,
} from '@ohos/scene.common/src/main/ets/framework/model/SettingItemModel';
import {
  notifyCompStateChange,
  SettingBaseState,
  SettingContentState,
  SettingModalState,
  SettingStateType,
} from '@ohos/scene.common/src/main/ets/framework/model/SettingStateModel';
import { ConfigType } from '@ohos/scene.datamanage/src/main/ets/model/base/ConfigType';
import { LoopType, TimeCondition } from '@ohos/scene.datamanage/src/main/ets/model/TriggerCondition';
import { ModeDetailAdapter, ParsedConfigData } from '@ohos/scene.configmanage/src/main/ets/adapter/ModeDetailAdapter';
import { TimePickerUtil } from '@ohos/scene.configmanage/src/main/ets/utils/TimePickerUtil';
import { NotDisturbUtils } from '@ohos/scene.notdisturb/src/main/ets/utils/NotDisturbUtils';
import { TimeManager } from '../../conditionsheet/timedsheet/manager/TimeManager';
import { LOOP_TYPE_CONTENT } from '../constant/HomeConstant';
import { HomeUtil } from '../utils/HomeUtil';

/* instrument ignore file */
const TAG: string = 'EnableWayController:';
const ADD_TRIGGERING_CONDITION_ID: string = 'add_triggering_condition';
const MAX_CONDITION_COUNT: number = 15;
const TIME_CONDITION_ICON: string = 'clock';

interface ConditionIconExtra {
  iconId: string;
  iconColor: ResourceColor;
}

@Builder
function conditionIconBuilder(param: object): void {
  Column() {
    SymbolGlyph($r(`sys.symbol.${((param as SettingItemModel).extra as ConditionIconExtra)?.iconId}`))
      .fontSize('16vp')
      .fontColor([$r('sys.color.icon_primary')])
      .draggable(false)
  }
  .justifyContent(FlexAlign.Center)
  .size({
    height: 24,
    width: 24,
  })
  .margin({
    end: PADDING_16,
  })
  .borderRadius(12)
  .backgroundColor(((param as SettingItemModel).extra as ConditionIconExtra)?.iconColor)
}

/**
 * 添加条件占位，宽度与上方条件图标一致，使文案与「单次」等标题对齐
 */
@Builder
function addConditionIndentBuilder(_param: object): void {
  Column()
    .size({
      height: 24,
      width: 24,
    })
    .margin({
      end: PADDING_16,
    })
}

/**
 * 条件开启分组控制器（仅定时条件）
 */
export class EnableWayController implements ComponentControl {
  private compId: string = '';
  private dataSource?: OrderedDataSource;

  private onRefreshAllModeDetailCallback = (): void => {
    this.reloadConditions();
  };

  private onRefreshModeDetailCallback = (configType: ConfigType): void => {
    if (configType === ConfigType.TRIGGER_CONDITION_TIME) {
      this.reloadConditions();
    }
  };

  private onScrollNewModeCallback = (): void => {
    this.reloadConditions();
  };

  init(compParam: CompCtrlParam): void {
    if (!compParam?.compId) {
      LogUtil.showError(TAG, 'init fail, compParam is invalid');
      return;
    }
    this.compId = compParam.compId;
    this.dataSource = compParam.dataSource as OrderedDataSource;
    this.reloadConditions();
    EventBus.getInstance().on(EventBusNameConstant.ALL_MODE_DETAIL_REFRESH, this.onRefreshAllModeDetailCallback);
    EventBus.getInstance().on(EventBusNameConstant.MODE_DETAIL_REFRESH, this.onRefreshModeDetailCallback);
    EventBus.getInstance().on(EventBusNameConstant.SCROLL_NEW_MODE, this.onScrollNewModeCallback);
  }

  destroy(): void {
    EventBus.getInstance().detach(EventBusNameConstant.ALL_MODE_DETAIL_REFRESH, this.onRefreshAllModeDetailCallback);
    EventBus.getInstance().detach(EventBusNameConstant.MODE_DETAIL_REFRESH, this.onRefreshModeDetailCallback);
    EventBus.getInstance().detach(EventBusNameConstant.SCROLL_NEW_MODE, this.onScrollNewModeCallback);
  }

  private reloadConditions(): void {
    LogUtil.showInfo(TAG, 'reloadConditions');
    this.dataSource?.splice(0, this.dataSource?.length);
    const timeConditions: ParsedConfigData[] =
      ModeDetailAdapter.getInstance().getParsedConfigDataByType([ConfigType.TRIGGER_CONDITION_TIME]);
    timeConditions.forEach((config: ParsedConfigData) => {
      this.dataSource?.pushData(this.buildTimeConditionItem(config));
    });
    const totalCount: number = timeConditions.length;
    this.refreshFooterText(totalCount);
    if (totalCount < MAX_CONDITION_COUNT) {
      this.dataSource?.pushData(this.buildAddConditionItem(totalCount > 0));
    }
  }

  private refreshFooterText(totalCount: number): void {
    const footerContent: Resource = HomeUtil.getTriggerConditionFooter(totalCount);
    notifyCompStateChange(`${this.compId}.footer`, new Map<SettingStateType, SettingBaseState>([
      [SettingStateType.STATE_TYPE_GROUP_FOOTER_CONTENT, { content: footerContent } as SettingContentState],
    ]));
  }

  /**
   * 与定时半模态「开启」开关同步：TimeCondition.enable 为 true → 已开启，false → 已关闭
   */
  private getEnableStatus(isEnabled: boolean): Resource {
    return isEnabled ? $r('app.string.not_disturb_turnedon') : $r('app.string.not_disturb_closed');
  }

  /**
   * 条件标题：每周展示选中的具体星期（如「周一 周二 周六」），其余类型仍用固定重复文案
   */
  private getConditionTitle(timeCondition: TimeCondition): ResourceStr {
    if (timeCondition.loopType === LoopType.EVERY_WEEK) {
      // expandWorkDays=false：与产品图一致，周一至周五也逐日展示，支持换行
      return TimePickerUtil.getDaysOfWeekDesc(timeCondition.loopDays, false);
    }
    const loopTypeIndex: number = Math.max(timeCondition.loopType - 1, 0);
    return LOOP_TYPE_CONTENT[loopTypeIndex] ?? LOOP_TYPE_CONTENT[0];
  }

  private buildTimeConditionItem(config: ParsedConfigData): ComparableSettingItemModel {
    const timeCondition: TimeCondition = config.parsedValue as TimeCondition;
    const title: ResourceStr = this.getConditionTitle(timeCondition);
    const timeSummary: string =
      `${NotDisturbUtils.getSysFormatTime(timeCondition.timeStart)}-${NotDisturbUtils.getEndTimeSummary(
        timeCondition.timeStart, timeCondition.timeEnd)}`;
    const iconExtra: ConditionIconExtra = {
      iconId: TIME_CONDITION_ICON,
      iconColor: $r('sys.color.comp_background_tertiary'),
    };
    return {
      id: `time_condition_${config.configId}`,
      type: ItemType.ITEM_TYPE_STANDARD,
      icon: {
        builder: wrapBuilder(conditionIconBuilder),
        iconType: SettingIconType.ICON_TYPE_TIP,
      },
      title: {
        content: title,
        // 多天星期名较长时允许换行，与条件区截图一致
        style: timeCondition.loopType === LoopType.EVERY_WEEK ? { maxLines: 3, wordBreak: WordBreak.BREAK_WORD } : undefined,
      },
      desp: {
        content: timeSummary,
        textType: SettingTextType.TEXT_TYPE_SECONDARY,
      },
      result: {
        type: ItemResultType.RESULT_TYPE_TEXT,
        result: { content: this.getEnableStatus(!!timeCondition.enable) },
      },
      detail: {
        type: ItemDetailType.DETAIL_TYPE_MODAL,
        destination: ModalSheetKey.TIMED_SHEET,
        icon: $r('app.media.ic_settings_arrow'),
        sheetOptions: {
          detents: [SheetSize.LARGE],
        },
        onItemClick: () => {
          TimeManager.getInstance().isAdd = false;
          TimeManager.getInstance().filInfo(config);
        },
      },
      extra: iconExtra,
    };
  }

  private buildAddConditionItem(alignWithConditionTitle: boolean): ComparableSettingItemModel {
    const menuItems: MenuItemOptions[] = [
      { content: $r('app.string.timed') },
    ];
    const item: ComparableSettingItemModel = {
      id: ADD_TRIGGERING_CONDITION_ID,
      type: ItemType.ITEM_TYPE_STANDARD,
      title: {
        content: $r('app.string.add_condition'),
        style: { fontColor: $r('sys.color.font_emphasize') },
      },
      detail: {
        type: ItemDetailType.DETAIL_TYPE_MENU,
        menu: {
          items: menuItems,
          isHideSelected: true,
          onSelected: (_index: number) => {
            this.openTimedSheet(true);
          },
        },
      },
    };
    // 已有条件时与上方标题对齐；无条件时靠左展示
    if (alignWithConditionTitle) {
      item.icon = {
        builder: wrapBuilder(addConditionIndentBuilder),
        iconType: SettingIconType.ICON_TYPE_TIP,
      };
    }
    return item;
  }

  private openTimedSheet(isAdd: boolean): void {
    if (isAdd) {
      TimeManager.getInstance().init();
    }
    notifyCompStateChange(`${HOME_PAGE_ID}.${HOME_MODAL_GROUP_ID}.${ModalSheetKey.TIMED_SHEET}`,
      new Map<SettingStateType, SettingBaseState>([
        [SettingStateType.STATE_TYPE_ITEM_SHEET, { state: true } as SettingModalState],
      ]));
  }
}
