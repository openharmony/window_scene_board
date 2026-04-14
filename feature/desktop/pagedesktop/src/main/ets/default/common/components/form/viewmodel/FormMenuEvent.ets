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
import { display } from '@kit.ArkUI';
import type abilityCommon from '@ohos.app.ability.common';
import {
  AppStorageUtil,
  DataProperty,
  LogDomain,
  LogHelper,
  RectInfo
} from '@ohos/basicutils';
import { DeviceHelper, EventConstants, GlobalContext, localEventManager } from '@ohos/frameworkwrapper';
import { NumberConstants } from '@ohos/commonconstants';
import { launcherStatusUtil } from '@ohos/windowscene';
import { ItemUtils } from '@ohos/componenthelper';
import {
  CardItemInfo,
  ClickCardShortcutMenuEvent,
  CommonConstants,
  Extend1Data,
  FormHiSysEventReporter,
  FormCommonUtil,
  MenuInfo,
  ShortcutMenuClickType,
  StyleConstants,
  ScreenSplitUtil,
  PageDesktopViewModelForPC
} from '@ohos/launchercommon/src/main/ets/TsIndex';

import { MenuCommonUtil } from '@ohos/launchercommon/Index';
import { FormHiSysEventUtil } from '@ohos/form';
import { FormZoomViewManager } from '@ohos/launchercommon/src/main/ets/manager/FormZoomViewManager';
import FormStyleConstants from '@ohos/form/src/main/ets/default/common/constants/FormStyleConstants';
import { FormMenuVm } from './FormMenuVm';

const TAG = 'FormMenuEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

// 菜单的GROUP数
const GROUP_NUM = 1;

export class FormMenuEvent {
  private mFormMenuVm: FormMenuVm;
  private desktopContext: abilityCommon.ServiceExtensionContext = GlobalContext.getContext();
  private mSetFormOpacity?: (opacity: number) => void;
  private mSetAppNameDisappear?: (isDisappear: boolean) => void;

  constructor(menuVm: FormMenuVm) {
    this.mFormMenuVm = menuVm;
  }

  public initMenuFunc(setFormOpacity?: (opacity: number) => void,
    setAppNameDisappear?: (isDisappear: boolean) => void): void {
    this.mSetFormOpacity = setFormOpacity;
    this.mSetAppNameDisappear = setAppNameDisappear;
  }

  private getMenuAnimationToScale(cardDimension: number): number {
    if (launcherStatusUtil.getShowOutLauncherStatus() && cardDimension === CommonConstants.CARD_DIMENSION_4x4) {
      return StyleConstants.MENU_ANIMATION_TO_SCALE;
    }
    return StyleConstants.MENU_ANIMATION_TO;
  }

  public longPressContext(cardDimension: number, offset: Position,
    formZoomPreviewBuilder?: CustomBuilder): ContextMenuOptions {
    return {
      backgroundBlurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
      borderRadius: StyleConstants.MENU_EXTERNAL_RADIUS,
      preview: formZoomPreviewBuilder || MenuPreviewMode.IMAGE,
      layoutRegionMargin: formZoomPreviewBuilder ? { left: 0, right: 0 } : undefined,
      offset: offset,
      placement: this.mFormMenuVm.mItemPlacement,
      onDidDisappear: () => {
        log.showWarn('longPressContext menu onDidDisappear');
        this.mSetFormOpacity?.(1);
        FormZoomViewManager.getInstance().showFormZoomView();
        this.setMenuShowState(false);
        this.mSetAppNameDisappear?.(false);
        this.mFormMenuVm.mIsHiddenEffect = false;
        this.desktopContext?.eventHub.emit('AIBarShow', false);
        this.desktopContext?.eventHub.emit(CommonConstants.EVENTHUB_FORM_MENU_DISAPPEAR);
      },
      onWillAppear: () => {
        localEventManager.sendLocalEventSticky(
          EventConstants.EVENT_DESKTOP_MENU_EVENT, CommonConstants.SCALE_FACTOR_WHEN_MENU_SHOW);
      },
      onWillDisappear: () => {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_DESKTOP_MENU_EVENT,
          NumberConstants.CONSTANT_NUMBER_ONE);
      },
      previewAnimationOptions: {
        scale: [
          StyleConstants.MENU_ANIMATION_FROM,
          formZoomPreviewBuilder ? StyleConstants.MENU_ANIMATION_FROM : this.getMenuAnimationToScale(cardDimension)
        ],
        transition: this.mFormMenuVm.mIsHiddenEffect ? TransitionEffect.asymmetric(
          TransitionEffect.opacity(0),
          TransitionEffect.IDENTITY.animation({ duration: 0 })) : undefined,
      },
      transition: this.mFormMenuVm.mIsHiddenEffect ? TransitionEffect.asymmetric(
        TransitionEffect.opacity(0),
        TransitionEffect.IDENTITY.animation({ duration: 0 })) : undefined,
    };
  }

  public longPressPCContext(): ContextMenuOptions {
    return {
      backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR,
      preview: MenuPreviewMode.IMAGE,
      placement: this.mFormMenuVm.mItemPlacement,
      onDisappear: () => {
        log.showWarn('longPressPCContext menu onDisappear');
        this.mSetFormOpacity?.(1);
        this.setMenuShowState(false);
        this.desktopContext?.eventHub.emit(CommonConstants.EVENTHUB_FORM_MENU_DISAPPEAR);
      },
      previewAnimationOptions: {
        scale: [StyleConstants.MENU_ANIMATION_FROM, StyleConstants.MENU_ANIMATION_FROM]
      },
      transition: TransitionEffect.asymmetric(
        TransitionEffect.opacity(0),
        TransitionEffect.IDENTITY.animation({ duration: 0 })),
      layoutRegionMargin: DeviceHelper.isBigScreenMachine() ? { top: 0, left: 0, right: 0, bottom: 0 } : undefined
    };
  }

  public rightClickContext(): ContextMenuOptions {
    return {
      backgroundBlurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
      onDisappear: () => {
        log.showWarn('rightClickContext menu onDisappear');
        this.mSetFormOpacity?.(1);
        this.mSetAppNameDisappear?.(false);
        this.desktopContext?.eventHub.emit('AIBarShow', false);
        this.desktopContext?.eventHub.emit(CommonConstants.EVENTHUB_FORM_MENU_DISAPPEAR);
      },
      previewAnimationOptions: {
        scale: [StyleConstants.MENU_ANIMATION_FROM, StyleConstants.MENU_ANIMATION_TO],
        transition: this.mFormMenuVm.mIsHiddenEffect ? TransitionEffect.asymmetric(
          TransitionEffect.opacity(0),
          TransitionEffect.IDENTITY.animation({ duration: 0 })) : undefined,
      },
      transition: this.mFormMenuVm.mIsHiddenEffect ? TransitionEffect.asymmetric(
        TransitionEffect.opacity(0),
        TransitionEffect.IDENTITY.animation({ duration: 0 })) : undefined,
    };
  }

  public rightClickPCContext(): ContextMenuOptions {
    return {
      backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR,
      onDisappear: () => {
        log.showWarn('rightClickPCContext menu onDisappear');
        this.mSetFormOpacity?.(1);
        this.desktopContext?.eventHub.emit(CommonConstants.EVENTHUB_FORM_MENU_DISAPPEAR);
      },
      previewAnimationOptions: {
        scale: [StyleConstants.MENU_ANIMATION_FROM, StyleConstants.MENU_ANIMATION_FROM]
      },
    };
  }

  public reportClickShortcutMenuEvent(isClicked: boolean, width: number, height: number, formItem: CardItemInfo): void {
    if (isClicked) {
      return;
    }
    const item: CardItemInfo = formItem;
    if (!item || !item.area || item.area.length === 0) {
      log.showWarn('report shortcut menu operation failed, item or the area of item is invalid.');
      return;
    }
    let dpSize: string = width + '*' + height;
    let event: ClickCardShortcutMenuEvent = {
      packageName: item.bundleName,
      area: item.area,
      dpSize: dpSize,
      formId: item.cardId.toString(),
      moduleName: item.moduleName,
      formName: item.cardName,
      menuType: ShortcutMenuClickType.NO_CLICK,
      // 普通卡片
      infoType: 0,
      sourceType: Extend1Data.getCardSourceType(item.extend1),
      formType: FormCommonUtil.getFormType(item.gameCardInfo),
    };
    FormHiSysEventReporter.reportGoIntoCardShortcutMenu(event);
    FormHiSysEventUtil.reportIntoFormType('1');
  }

  public menuAppearHandler(isLongPress: boolean): void {
    if (DeviceHelper.isPC()) {
      return;
    }
    if (isLongPress) {
      this.mSetFormOpacity?.(FormStyleConstants.DEFAULT_FORM_HIDDEN_OPACITY_VALUE);
      FormZoomViewManager.getInstance().hideFormZoomView();
    }
    this.mSetAppNameDisappear?.(true);
    this.desktopContext?.eventHub.emit('AIBarShow', true);
  }

  public menuDisappearHandler(isClick: boolean, width: number, height: number, formItem: CardItemInfo): void {
    this.reportClickShortcutMenuEvent(isClick, width, height, formItem);
    AppStorageUtil.setOrCreate('formBlur', false, new DataProperty(true, false));
    AppStorageUtil.setOrCreate('notifyEnterFormManagerAnimate', formItem?.cardId, new DataProperty(true, false));
  }

  public setMenuShowState(state: boolean): void {
    this.mFormMenuVm.mIsMenuShow = state && !ScreenSplitUtil.isScreenSplit(TAG);
  }

  public setAppMenuPosition(event: TouchEvent, componentId: string, menuInfoList: MenuInfo[]): void {
    if (event.type === TouchType.Down) {
      if (DeviceHelper.isPC()) {
        const placement = PageDesktopViewModelForPC.getInstance().getRightMenuViewModel()?.getMenuPlacement(event,
          menuInfoList, TAG);
        if (placement) {
          this.mFormMenuVm.mItemPlacement = placement;
        }
        return;
      }
      display.getAllDisplays((err, data) => {
        if (err.code) {
          log.error('Failed error: ', err);
          return;
        }

        let menuItemNum = menuInfoList?.length ?? 0;
        let formRect: RectInfo = ItemUtils.getRectById(componentId);
        this.mFormMenuVm.mItemPlacement = MenuCommonUtil.getMenuPlacement(event, formRect, menuItemNum, GROUP_NUM);
      });
    }
  }
}