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

import { LogDomain, CheckEmptyUtils, Logger } from '@ohos/basicutils';
import { IconExtendParam, IconResourceManager } from '@ohos/frameworkwrapper';
import { AppItemInfo, CardItemInfo, CommonConstants, FormEditViewParam, FormModel } from '@ohos/launchercommon';
import FormConstants from '@ohos/form/src/main/ets/default/common/constants/FormConstants';
import { FormEditViewLayout } from './FormEditLayout';
import { FormEditViewProxy } from './FormEditViewProxy';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { FormEditSecViewProxy } from './FormEditSecViewProxy';
import { FormEditWindowManager } from './FormEditWindowManager';
import window from '@ohos.window';

const TAG = 'FormEditViewPC';
const log = Logger.getLogHelper(LogDomain.FORM);

@Component
export struct FormEditView {
  @State isViewShow: boolean = false;
  @State appName: string = '';
  @State appIcon: string | PixelMap = '';
  @State formEditLayout: FormEditViewLayout = new FormEditViewLayout();
  @State showMask: boolean = false;
  @State isFocus: boolean = true;
  private appInfo: AppItemInfo = new AppItemInfo();
  private launchCardInfo: CardItemInfo = new CardItemInfo();
  private focusCallback: Callback<window.WindowEventType> = windowEventType => {
    log.showInfo(TAG, `focusCallback, windowEventType:${windowEventType}`);
    if (windowEventType === window.WindowEventType.WINDOW_ACTIVE) {
      this.isFocus = true;
    }
    if (windowEventType === window.WindowEventType.WINDOW_INACTIVE) {
      this.isFocus = false;
    }
  }

  private updateTitle(): void {
    const iconResourceManager: IconResourceManager = IconResourceManager.getInstance();
    this.appName = this.appInfo.applicationName ?? '';
    if (CheckEmptyUtils.checkStrIsEmpty(this.appName)) {
      this.appName = iconResourceManager.getAppNameByCache(this.appInfo.appLabelId, this.appInfo.bundleName,
        this.appInfo.moduleName, this.appInfo.abilityName);
    }
    log.showInfo(TAG, `update appName:${this.appName}`);
    this.setMissionName(this.appName);
    iconResourceManager.getCombineIcon(this.appInfo.bundleName,
      this.appInfo.moduleName, this.appInfo.abilityName, new IconExtendParam()).then((icon: PixelMap) => {
      this.appIcon = icon;
      log.showInfo(TAG, `update appIcon is invalid ${!!icon}`);
      this.setMissionIcon(this.appIcon);
    }).catch((err: BusinessError) => {
      log.showWarn(TAG, `getCombineIcon error, errCode:${err?.code}, errMessage:${err?.message}`);
    });
  }

  private setMissionName(appName: string): void {
    const uiAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    uiAbilityContext.setMissionLabel(appName)
      .catch((err: BusinessError) => log.showError(TAG, `setMissionLabel error, errCode:${err?.code}, errMsg:${err?.message}`));
  }

  private setMissionIcon(appIcon: PixelMap): void {
    const uiAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    uiAbilityContext.setMissionIcon(appIcon)
      .catch((err: BusinessError) => log.showError(TAG, `setMissionIcon error, errCode:${err?.code}, errMsg:${err?.message}`));
  }

  private initViewParam(): void {
    const viewParam: FormEditViewParam | undefined = FormEditViewProxy.getInstance().getViewParam();
    log.showInfo(TAG, `initViewParam, bundleName:${viewParam?.bundleName}, cardID:${viewParam?.formInfo?.cardId},\
    cardName:${viewParam?.formInfo?.cardName}`);
    this.formEditLayout = FormEditViewProxy.getInstance().formEditViewLayout;
    const cardAppInfo = FormModel.getInstance().getAppInfoByBundleName(viewParam?.bundleName ?? '');
    if (cardAppInfo) {
      this.appInfo = cardAppInfo;
    } else {
      log.showWarn(TAG, `appInfo is null, bundleName:${viewParam?.bundleName}`);
    }
    if (viewParam?.formInfo) {
      this.launchCardInfo = viewParam.formInfo;
    }
  }

  private updateView(): void {
    log.showInfo(TAG, 'updateView');
    this.initViewParam();
    this.updateTitle();
  }

  aboutToAppear(): void {
    FormEditViewProxy.getInstance().registerViewChangeListener(() => this.updateView());
    this.initViewParam();
    this.updateTitle();
    FormEditSecViewProxy.getInstance().registerViewStateChangeListener(isShow => this.showMask = isShow);
    FormEditWindowManager.getInstance().registerFormEditWindowEventListener(this.focusCallback);
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, 'aboutToDisappear');
    FormEditViewProxy.getInstance().unregisterViewChangeListener();
    FormEditSecViewProxy.getInstance().unregisterViewStateChangeListener();
    FormEditWindowManager.getInstance().unregisterFormEditWindowEventListener(this.focusCallback);
  }

  @Builder
  appIconBuilder() {
    Image(this.appIcon)
      .draggable(false)
      .id(`${TAG}_Image_${this.appName}`)
      .width(24)
      .height(24)
      .objectFit(ImageFit.Fill)
      .autoResize(false)
      .interpolation(ImageInterpolation.Medium)
      .borderRadius(4)
  }

  @Builder
  appNameBuilder() {
    Text(this.appName)
      .id(`${TAG}_Text_${this.appName}`)
      .draggable(false)
      .fontSize($r('sys.float.Subtitle_M'))
      .fontFamily('HarmonyHeiTi')
      .fontWeight(FontWeight.Medium)
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .maxLines(1)
      .textOverflow({
        overflow: TextOverflow.Ellipsis
      })
      .maxFontScale(1.45)
  }

  @Builder
  titleBuilder() {
    Row() {
      this.appIconBuilder()
      Blank().width(12)
      this.appNameBuilder()
    }
    .size({ width: this.formEditLayout.getContentWidth(), height: this.formEditLayout.titleHeight })
    .opacity(this.isFocus ? 1 : $r('sys.float.alpha_disable'))
    .justifyContent(FlexAlign.Start)
  }

  @Builder
  editContentBuilder() {
      UIExtensionComponent({
        bundleName: this.launchCardInfo.bundleName,
        abilityName: this.launchCardInfo.formConfigAbility?.slice(CommonConstants.FORM_CONFIG_ABILITY_PREFIX.length),
        parameters: {
          'ability.want.params.uiExtensionType': FormConstants.FORM_EDIT_UI_EXTENSION_TYPE,
          'cardId': this.launchCardInfo.cardId,
        }
      })
        .accessibilityUseSamePage(AccessibilitySamePageMode.FULL_SILENT)
        .onRemoteReady((proxy: UIExtensionProxy) => {
          log.showInfo(TAG, 'UIExtensionComponent onRemoteReady');
        })
        .onTerminated((info: TerminationInfo) => {
          log.showInfo(TAG, 'UIExtensionComponent onTerminated');
        })
        .onError((err) => {
          log.showError(TAG, `UIExtensionComponent onError, code:${err?.code}, msg:${err?.message}`);
        })
        .id(`${TAG}_FormEditView`)
        .clip(true)
        .size({ width: this.formEditLayout.getContentWidth(), height: this.formEditLayout.getContentHeight() })
        .backgroundColor(Color.Transparent)
        .margin({ top: this.formEditLayout.contentMarginTop })
  }

  @Builder
  finishButtonBuilder() {
    Button($r('app.string.form_edit_finish'), { type: ButtonType.Normal })
      .size({ width: this.formEditLayout.getContentWidth(), height: this.formEditLayout.buttonHeight })
      .fontWeight(FontWeight.Medium)
      .fontSize(16)
      .fontFamily('HarmonyHeiTi')
      .borderRadius(8)
      .margin({ top: this.formEditLayout.contentMarginBottom })
      .onClick(() => {
        FormEditViewProxy.getInstance().closeView('operate finish');
      })
  }

  build() {
    Stack() {
      Column() {
        this.titleBuilder()
        this.editContentBuilder()
        this.finishButtonBuilder()
      }
      .size({ width: '100%', height: '100%' })
      .backgroundColor($r('sys.color.comp_background_gray'))

      if (this.showMask) {
        Column()
          .size({ width: '100%', height: '100%' })
          .backgroundColor($r('sys.color.mask_fourth'))
      }
    }
    .size({ width: '100%', height: this.formEditLayout.getFormEditHeight() })
  }
}