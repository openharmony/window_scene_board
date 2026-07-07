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

import type ctx from '@ohos.app.ability.common';
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  CloseAppManager,
  GridLayoutItemInfo,
  StyleConstants
} from '@ohos/launchercommon';
import { ResUtils } from '@ohos/windowscene';
import { AiSuggestionAppIcon } from './AiSuggestionAppIcon';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AiSuggestionAppGroupCallback, AiSuggestionAppGroupManager } from '../manager/AiSuggestionAppGroupManager';
import { AiSuggestionAnimHelper } from '../animation/AiSuggestionAnimHelper';
import { AiSuggestionDataProcess } from '../helper/AiSuggestionDataProcess';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { LongPressType } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';

const TAG = 'AiSuggestionAppGroup';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

@Component
export struct AiSuggestionAppGroup {
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @State subItems: LauncherRecItem[] = [];
  @Prop iconSize: number = 0;
  @Prop iconRadius: number = 0;
  @Prop formBorderRadius: number = ResUtils.getNumber($r('app.float.form_corner_radius'));
  @Prop gridPadding: number = 0;
  @Prop @Watch('formPressTypeChange') mFormPressType: LongPressType = LongPressType.DEFAULT;
  @State selectItem: LauncherRecItem | undefined = undefined;
  @Prop appGroupBgColor: ResourceColor = '';
  @Prop changedItemIdsSet: Set<string> = new Set<string>();
  private desktopContext?: ctx.ServiceExtensionContext = GlobalContext.getContext();
  selectIndex: number = -1;
  formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  recItem: LauncherRecItem = new LauncherRecItem();
  disappearLastIndex: number = 0;
  setSelectItemOnTouch?: (recItem: LauncherRecItem, event: TouchEvent, index: number) => void;
  setSelectItemOnHover?: (recItem: LauncherRecItem, isHover: boolean, event: HoverEvent, index: number) => void
  recItemIndex: number = -1;
  private groupKey = '';
  private formCallback: AiSuggestionAppGroupCallback = {
    onUpdate: (recItem: LauncherRecItem): void => {
      try {
        const changedItemRecord =
          AiSuggestionDataProcess.updateChangedItemRecord(this.subItems, recItem.subLauncherRecItems);
        this.changedItemIdsSet = changedItemRecord.diffIdSet as Set<string>;
        this.disappearLastIndex = changedItemRecord.disappearLastIndex as number;
        this.subItems = recItem.subLauncherRecItems;
        AiSuggestionAppGroupManager.getInstance().setRecItem(this.groupKey, recItem);
        log.showInfo('update subItems');
      } catch (err) {
        log.showError(`onUpdate error ${err}`);
      }
    }
  };

  private formPressTypeChange(): void {
    log.showInfo(`formPressTypeChange ${this.mFormPressType}, selectIndex = ${this.selectIndex}`);
    if (this.mFormPressType === LongPressType.DEFAULT) {
      this.selectItem = undefined;
      this.selectIndex = -1;
    } else if (this.mFormPressType === LongPressType.SELECTED_ITEM) {
      if (this.selectIndex !== -1) {
        this.selectItem = this.subItems[this.selectIndex]
      }
    }
  }

  aboutToAppear(): void {
    this.subItems = this.recItem.subLauncherRecItems;
    this.groupKey = `${this.formItem.cardId}_${this.recItem.rowStart}_${this.recItem.columnStart}`;
    log.showInfo(`aboutToAppear groupKey: ${this.groupKey}`);
    AiSuggestionAppGroupManager.getInstance().setRecItem(this.groupKey, this.recItem);
    AiSuggestionAppGroupManager.getInstance().registerCallback(this.groupKey, this.formCallback);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear groupKey: ${this.groupKey}`);
    AiSuggestionAppGroupManager.getInstance().unRegisterCallback(this.groupKey, this.formCallback);
  }

  build() {
    Row({ space: 5.72 }) {
      ForEach(this.subItems, (subApp: LauncherRecItem, index: number) => {
        this.appItemBuilder(subApp, this.recItemIndex, true, index);
      }, (subApp: LauncherRecItem) => LauncherRecItem.getItemUniqueKey(this.formItem, subApp))
    }
    .justifyContent(FlexAlign.Center)
    .borderRadius(this.formBorderRadius - this.gridPadding)
    .clip(true)
    .backgroundColor(this.appGroupBgColor)
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
  }

  @Builder
  appItemBuilder(recItem: LauncherRecItem, recItemIndex: number, needTransition: boolean, index: number) {
    AiSuggestionAppIcon({
      iconSize: this.iconSize,
      iconRadius: this.iconRadius,
      isAccessibilityMode: this.isAccessibilityMode,
      recItem: recItem,
      recItemIndex: recItemIndex,
      needTransition: needTransition,
      formItem: this.formItem,
      recItems: this.subItems,
      disappearLastIndex: this.disappearLastIndex,
      selectItem: this.selectItem,
      iconSelectItemOnTouch: (event: TouchEvent): void => {
        this.setSelectItemOnTouch?.(recItem, event, recItemIndex);
        if (event?.type === TouchType.Down) {
          CloseAppManager.getInstance().setAdaptiveIcon(recItem.bundleName,
            recItem.moduleName, recItem.abilityName, recItem.appIconId);
          this.selectIndex = index;
        } else if (event?.type === TouchType.Up || event?.type === TouchType.Cancel) {
          this.selectIndex = -1;
        }
      },
      iconSelectItemOnHover: (isHover: boolean, event: HoverEvent) => {
        this.setSelectItemOnHover?.(recItem, isHover, event, recItemIndex);
      },
    }).transition(AiSuggestionAnimHelper.getTransition(recItem, recItemIndex, this.changedItemIdsSet,
      this.disappearLastIndex))
  }
}