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

import { LogDomain, Logger } from '@ohos/basicutils';
import { FormEditViewManager } from '@ohos/launchercommon';
import { FormEditViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormEditViewManager';
import FormConstants from '@ohos/form/src/main/ets/default/common/constants/FormConstants';
import { FormEditSecViewProxy } from './FormEditSecViewProxy';
import { LengthMetrics, window } from '@kit.ArkUI';
import { KeyCode } from '@kit.InputKit';
import { FormEditSecViewLayout } from './FormEditLayout';
import { FormEditWindowManager } from './FormEditWindowManager';

const TAG = 'FormEditSecViewPC';
const log = Logger.getLogHelper(LogDomain.FORM);

@Component
export struct FormEditSecView {
  @State isViewShow: boolean = false;
  @State isCloseIconHover: boolean = false;
  @State isFocus: boolean = true;
  private formEditViewParam: FormEditViewParam = new FormEditViewParam();
  private formEditLayout: FormEditSecViewLayout = new FormEditSecViewLayout();
  private focusCallback: Callback<window.WindowEventType> = windowEventType => {
    log.showInfo(TAG, `focusCallback, windowEventType:${windowEventType}`);
    if (windowEventType === window.WindowEventType.WINDOW_ACTIVE) {
      this.isFocus = true;
    }
    if (windowEventType === window.WindowEventType.WINDOW_INACTIVE) {
      this.isFocus = false;
    }
  }

  aboutToAppear(): void {
    log.showInfo(TAG, 'aboutToAppear');
    const formEditViewParam = FormEditSecViewProxy.getInstance().formEditViewParam;
    if (formEditViewParam) {
      this.formEditViewParam = formEditViewParam;
    }
    this.formEditLayout = FormEditSecViewProxy.getInstance().formEditLayout;
    FormEditWindowManager.getInstance().registerFormEditSecWindowEventListener(this.focusCallback);
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, 'aboutToDisappear');
    FormEditWindowManager.getInstance().unregisterFormEditSecWindowEventListener(this.focusCallback);
  }

  @Styles
  normalStyles() {
    .backgroundColor(this.isCloseIconHover ? $r('sys.color.interactive_hover') : '#00ffffff')
  }

  @Styles
  PressedStyles() {
    .backgroundColor($r('sys.color.interactive_pressed'))
  }

  @Builder
  editContentBuilder() {
      UIExtensionComponent({
        bundleName: this.formEditViewParam.bundleName,
        abilityName: this.formEditViewParam.secPageAbilityName,
        parameters: {
          'ability.want.params.uiExtensionType': FormConstants.FORM_EDIT_UI_EXTENSION_TYPE,
        }
      })
        .zIndex(0)
        .onRemoteReady((proxy: UIExtensionProxy) => {
          log.showInfo(TAG, 'UIExtensionComponent onRemoteReady');
        })
        .onTerminated((info: TerminationInfo) => {
          log.showInfo(TAG, 'UIExtensionComponent onTerminated');
          // 应用侧结束进程时关闭二级页面
          FormEditViewManager.getInstance().closeFormEditSecPageView();
        })
        .onError((err) => {
          log.showError(TAG, `UIExtensionComponent onError, code:${err?.code}, msg:${err?.message}`);
        })
        .id(`${TAG}_AppEditPageView`)
        .clip(true)
        .size({ width: '100%', height: '100%' })
  }

  @Builder
  titleBuilder() {
    Row() {
      Blank()
      this.closeIconBuilder()
    }
    .zIndex(100)
    .size({ width: this.formEditLayout.getFormEditWidth(), height: this.formEditLayout.titleHeight })
    .margin({ top: this.formEditLayout.closeButtonMarginTop })
    .opacity(this.isFocus ? 1 : $r('sys.float.alpha_disable'))
  }

  @Builder
  closeIconBuilder() {
    Column() {
      SymbolGlyph($r('sys.symbol.xmark'))
        .draggable(false)
        .id('close_image')
        .fontSize('24vp')
        .fontColor([$r('sys.color.icon_primary')])
    }
    .size({ width: this.formEditLayout.closeButtonSize, height: this.formEditLayout.closeButtonSize })
    .margin({ end: LengthMetrics.vp(this.formEditLayout.closeButtonMarginRight) })
    .borderRadius(8)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      FormEditViewManager.getInstance().closeFormEditSecPageView();
    })
    .onHover(isHover => this.isCloseIconHover = isHover)
    .stateStyles({
      normal: this.normalStyles,
      pressed: this.PressedStyles
    })
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      this.editContentBuilder()
      this.titleBuilder()
    }
    .key(TAG)
    .onAppear(() => {
      focusControl.requestFocus(TAG)
    })
    .onKeyEvent(event => {
      log.showInfo(TAG, `on key event, ${event.keyCode}`)
      if (event.keyCode === KeyCode.KEYCODE_ESCAPE && event.type === KeyType.Down) {
        FormEditViewManager.getInstance().closeFormEditSecPageView();
      }
    })
  }
}