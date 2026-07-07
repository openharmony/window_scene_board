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

import { systemDateTime } from '@kit.BasicServicesKit';
import { CheckEmptyUtils, LogDomain, LogHelper, StartType } from '@ohos/basicutils';
import { EventType, scbEventExclusiveManager, SCBSceneSessionManager, StartAbilityUtil } from '@ohos/windowscene';
import {
  AppIconCommonEvent,
  AppIconCommonView,
  AppIconConfig,
  AppIconContainerModifier,
  AppIconDefaultModifier,
} from '@ohos/launchercommon/Index';
import {
  AppDataWrapper,
  AppItemInfo,
  CloseAppManager,
  CommonConstants,
  DeliverUtil,
  editModeManager,
  EventConstants,
  GridLayoutItemInfo,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  AppIconTouchEventIface
} from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconTouchEventIface';
import {
  AppIconHoverEventIface
} from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconHoverEventIface';
import AiSuggestionActionManager from '../manager/AiSuggestionActionManager';
import { AiSuggestionEventReporter } from '../donate/AiSuggestionEventReporter';
import { AppIconData } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconData';
import { AppIconResIface } from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconResIface';
import { AiSuggestionResourceManager } from '../manager/AiSuggestionResourceManager';
import WantConstant from '@ohos.app.ability.wantConstant';
import { common } from '@kit.AbilityKit';
import { CommonUtil } from '../utils/CommonUtil';
import { AiSuggestionDataHelper } from '../helper/AiSuggestionDataHelper';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { AiSuggestionCache } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionCache';
import { localEventManager } from '@ohos/frameworkwrapper';

const TAG = 'AiSuggestionAppIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

@Component
export struct AiSuggestionAppIcon {
  @Prop iconSize: number = AiSuggestionConstants.APP_GROUP_DEFAULT_ICON_SIZE;
  @Prop iconRadius: number = CommonConstants.DEFAULT_ICON_RADIUS;
  @Prop changedItemIdsSet: Set<string> = new Set<string>();
  @Prop formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  @Prop disappearLastIndex: number = 0;
  @Prop recItem: LauncherRecItem = new LauncherRecItem();
  @Prop recItems: LauncherRecItem[] = [];
  @Prop @Watch('onIsAccessibilityModeChange') isAccessibilityMode: boolean = false;
  @Prop @Watch('selectedItemChange') selectItem: LauncherRecItem | undefined = undefined;
  @State iconData: AppIconData = new AppIconData();
  @Prop isEmptyBgColor: boolean = false;
  recItemIndex: number = -1;
  private touchTimestamp: number = 0;
  needTransition: boolean = false;
  private appIconContainerModifier: AppIconContainerModifier =
    new AppIconContainerModifier(() => this.updateModifier());
  private appIconConfig: AppIconConfig = new AppIconConfig();
  private iconEvent: AppIconCommonEvent = new AppIconCommonEvent();
  iconSelectItemOnTouch?: (event: TouchEvent) => void;
  iconSelectItemOnHover?: (isHover: boolean, event: HoverEvent) => void;

  private updateModifier(): void {
    this.appIconContainerModifier.attribute?.accessibilityLevel(this.isAccessibilityMode ? 'yes' : 'no');
    this.appIconContainerModifier.attribute?.accessibilityText(this.isAccessibilityMode ?
      `${this.recItem.appName}` : '');
  }

  private onIsAccessibilityModeChange(): void {
    // 更新无障碍参数
    this.updateModifier();
  }

  private selectedItemChange(): void {
    log.showInfo(`selectedItemChange ${this.selectItem?.bundleName}`);
    if (!this.selectItem || this.selectItem.bundleName === this.recItem.bundleName) {
      this.iconData.iconOpacity = AiSuggestionConstants.ITEM_SELECTED_OPACITY;
    } else {
      this.iconData.iconOpacity = AiSuggestionConstants.ITEM_NORMAL_OPACITY;
    }
  }

  private getAppItemKeyName(keyName: string, serviceId: string, cardId?: string): string {
    return `cardId:${cardId}${keyName}${serviceId}`;
  }

  private getAppItemByLauncherRecItem(recItem: LauncherRecItem): AppItemInfo {
    let appItem: AppItemInfo = new AppItemInfo();
    appItem.abilityName = recItem.abilityName;
    appItem.keyName = this.getAppItemKeyName(recItem.keyName, recItem.serviceId, this.formItem.cardId);
    appItem.bundleName = recItem.bundleName;
    appItem.moduleName = recItem.moduleName;
    appItem.appIconId = recItem.appIconId;
    appItem.appIndex = recItem.appIndex;
    return appItem;
  }

  private launchApp(item: LauncherRecItem): void {
    if (item.itemType !== CommonConstants.TYPE_APP) {
      return;
    }
    log.showWarn('launchApp bundleName:%{public}s, moduleName:%{public}s, abilityName:%{public}s, ' +
      'appIndex:%{public}d, appIconId:%{public}s, badgeNumber:%{public}d, empty deepLink:%{public}s',
      item.bundleName, item.moduleName, item.abilityName, item.appIndex, item.appIconId, item.badgeNumber,
      CheckEmptyUtils.checkStrIsEmpty(item.deepLink));
    CloseAppManager.getInstance().setStartAppType(StartType.AI_SUGGESTION_APP, undefined, this.formItem.cardId);
    if (item.bundleName.startsWith('com.atomicservice') && !CommonUtil.isInstalled(item.bundleName)) {
      const context = (getContext() as common.UIAbilityContext);
      context?.startAbility({
        bundleName: item.bundleName,
        moduleName: item.moduleName,
        abilityName: item.abilityName,
        flags: WantConstant.Flags.FLAG_INSTALL_ON_DEMAND,
        parameters: item.parameters
      });
    } else if (!CheckEmptyUtils.checkStrIsEmpty(item.deepLink) || !CheckEmptyUtils.isEmpty(item.parameters)) {
      StartAbilityUtil.startLauncherAbilityByWant({
        bundleName: item.bundleName,
        moduleName: item.moduleName,
        abilityName: item.abilityName,
        uri: item.deepLink,
        parameters: item.parameters
      });
    } else {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APP_DOUBLE_CLICK, {
        abilityName: item.abilityName,
        bundleName: item.bundleName,
        moduleName: item.moduleName,
        appIndex: item.appIndex
      });
    }
    AiSuggestionActionManager.getInstance()
      .clickRecItem(AiSuggestionDataHelper.getRealRecItem(item, this.recItems), this.formItem);
  }

  private initAppIconItemConfig(): void {
    let appData: AppDataWrapper =
      AppDataWrapper.getDefaultAppData(this.getAppItemByLauncherRecItem(this.recItem), this.iconRadius)
        .setExtraId(this.formItem.cardId)
        .setStartType(StartType.AI_SUGGESTION_APP);

    this.appIconConfig.setAppDataOfTransactionController(appData)
      .setEnableMultiSelect(false)
      .setEnableName(false)
      .setEnableDrag(false)
      .setEnableExtendResponseRegion(false)
      .setIsBadgeSmaller(!this.isEmptyBgColor)
      .setExternCb({
        onIconClick: (event?: ClickEvent, fingers?: number): void => {
          if (Date.now() - this.touchTimestamp >= 500) {
            log.showWarn('app icon in long press');
            return;
          }
          if (editModeManager.isInEditMode() || scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
            log.showWarn('in edit mode or gesture event exclusive');
            return;
          }
          this.launchApp(this.recItem);
          AiSuggestionEventReporter.getInstance().reportSuggestionFormIconClick(this.formItem, this.recItem);
        },
        onIconTouch: (event: TouchEvent): void => {
          if (event?.type === TouchType.Down) {
            this.touchTimestamp = Date.now();
          }
          this.iconSelectItemOnTouch?.(event);
        }
      });
  }

  private initIconEvent(): void {
    let iconHoverEventIface: AppIconHoverEventIface = {
      onHover: (isHover: boolean, event: HoverEvent, updateScale: (scale: number) => void): void => {
        this.iconSelectItemOnHover?.(isHover, event);
      }
    }

    let iconContainerEventIface: AppIconTouchEventIface = {
      onTouch: (event: TouchEvent): void => {
        if (event?.type === CommonConstants.TOUCH_TYPE_DOWN) {
          log.showInfo('on icon container touch down start');
          this.touchTimestamp = systemDateTime.getTime();
          if (DeliverUtil.isSupportAppType(this.recItem.bundleName) && DeliverUtil.isSupportDeliver()) {
            SCBSceneSessionManager.getInstance().preloadApp(this.recItem.bundleName);
          }
        }
      },
      onClick: (event?: ClickEvent | undefined): void => {
        log.showInfo('onClick icon');
        if (editModeManager.isInEditMode() || scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
          return;
        }
        this.launchApp(this.recItem);
        AiSuggestionEventReporter.getInstance().reportSuggestionFormIconClick(this.formItem, this.recItem);
      }
    }
    AiSuggestionCache.getInstance().deleteIconCache(this.recItem.bundleName + this.formItem.cardId);
    if (!CheckEmptyUtils.isEmpty(this.recItem.iconUrl)) {
      log.showInfo(`initIconEvent icon: ${this.recItem.iconUrl}`);
      const appIconResource: AppIconResIface = {
        initIconImage: (itemInfo: AppItemInfo): Promise<void> => {
          return this.getIconImage(itemInfo);
        },
      }
      this.iconEvent.setIconResIface(appIconResource);
    }
    this.iconEvent.setIconHoverEventIface(iconHoverEventIface);
    this.iconEvent.setIconContainerEventIface(iconContainerEventIface);
  }

  private async getIconImage(itemInfo: AppItemInfo): Promise<void> {
    if (!itemInfo || !this.iconData) {
      log.showError('getIconImage failed, itemInfo or iconData is invalid!');
      return;
    }
    const imageStr = await AiSuggestionResourceManager.getInstance().getResource(this.recItem.iconUrl);
    this.iconData.image = imageStr ?? ''
    AiSuggestionCache.getInstance().setIconCache(itemInfo.bundleName + this.formItem.cardId, imageStr);
    log.showInfo(`getIconImage cacheKey: ${itemInfo.bundleName + this.formItem.cardId} icon: ${imageStr?.length}`);
  }

  aboutToAppear(): void {
    this.initAppIconItemConfig();
    this.initIconEvent();
  }

  build() {
    AppIconCommonView({
      iconSize: this.iconSize,
      iconRadius: this.iconRadius,
      item: this.getAppItemByLauncherRecItem(this.recItem),
      appIconConfig: this.appIconConfig,
      iconEvent: this.iconEvent,
      iconModifier: new AiSuggestionAppIconDefaultModifier(),
      iconContainerModifier: this.appIconContainerModifier,
      iconData: this.iconData
    }).width(this.iconSize)
      .height(this.iconSize);
  }
}

/**
 * 控制语音助手建议图标属性：目前用于屏蔽图标组件长按手势，使用语音助手的手势
 */
class AiSuggestionAppIconDefaultModifier extends AppIconDefaultModifier {
  initializeModifier(instance: CommonAttribute): void {
    super.initializeModifier(instance);
    instance.onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent): GestureJudgeResult => {
      if (gestureInfo.type === GestureControl.GestureType.LONG_PRESS_GESTURE) {
        return GestureJudgeResult.REJECT;
      }
      return GestureJudgeResult.CONTINUE;
    })
  }
}