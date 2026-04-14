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

import { LogHelper, LogDomain } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  FormEditViewController,
  FormEditViewParam,
} from '@ohos/launchercommon/src/main/ets/manager/FormEditViewManager';
import { DeviceState, FormEditViewManager } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormEditViewData, SecPageViewData } from '../viewmodel/FormEditViewData';
import FormConstants from '../common/constants/FormConstants';

const TAG = 'FormEditSecPageView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export struct FormEditSecPageView {
  private mFormEditViewManager: FormEditViewManager = FormEditViewManager.getInstance();
  private mFormEditViewPam: FormEditViewParam = new FormEditViewParam();
  private mViewController: FormEditViewController = {
    showView: async (param: FormEditViewParam): Promise<void> => {
      this.showView(param);
    },
    closeView: () => {
      this.closeView();
    },
    hideView: () => {
      this.closeView();
    },
    getViewState: () => {
      return this.mEditSecPageShow;
    },
    backGestureHandler: () => {
      this.closeView();
    }
  };
  @State mViewData: SecPageViewData = new SecPageViewData();
  @State mEditSecPageShow: boolean = false;
  @State mBindSheetHeight: number = 0;
  @StorageProp('lockReceived') @Watch('closeView') lockReceived: number = 0;
  @StorageProp('folderStatus') @Watch('closeView') folderStatus: number = DeviceState.DEFAULT_STATE;

  private showView(param: FormEditViewParam): void {
    this.mFormEditViewPam = param;

    if (this.mEditSecPageShow) {
      if (this.mBindSheetHeight !== 0) {
        log.showInfo('showView reentrant, do nothing');
        return;
      }
      this.mBindSheetHeight = this.mViewData.bindSheetHeight;
      log.showInfo(`FormEditSecPage current height: ${this.mBindSheetHeight}`);
      return;
    }

    this.mViewData = FormEditViewData.getInstance().getViewData().formSecPageViewData;
    this.mBindSheetHeight = this.mViewData.bindSheetHeight;
    this.mEditSecPageShow = true;
    log.showWarn(`mEditSecPageShow: ${this.mEditSecPageShow}, mViewData: ${JSON.stringify(this.mViewData)}`);
  }

  private closeView(): void {
    if (!this.mEditSecPageShow) {
      return;
    }
    this.mEditSecPageShow = false;
  }

  aboutToAppear(): void {
    log.showInfo('FormEditSecPage aboutToAppear');
    this.mFormEditViewManager.registerFormEditSecPageController(this.mViewController);
  }

  aboutToDisappear(): void {
    log.showInfo('FormEditSecPage aboutToDisappear');
    this.mFormEditViewManager.unRegisterFormEditSecPageController();
  }

  @Builder
  formEditSecPageBuilder() {
    UIExtensionComponent({
      bundleName: this.mFormEditViewPam.bundleName,
      abilityName: this.mFormEditViewPam.secPageAbilityName,
      parameters: {
        'ability.want.params.uiExtensionType': FormConstants.FORM_EDIT_UI_EXTENSION_TYPE,
      }
    })
      .onRemoteReady((proxy: UIExtensionProxy) => {
        log.showWarn('UIExtensionComponent onRemoteReady');
      })
      .onTerminated((info: TerminationInfo) => {
        log.showWarn('UIExtensionComponent onTerminated');

        // 应用侧结束进程时关闭二级页面
        this.mFormEditViewManager.closeFormEditSecPageView();
      })
      .onError((err) => {
        log.showError(`UIExtensionComponent onError, code: ${err?.code}`);
      })
      .id(`${TAG}_AppEditPageView`)
      .clip(true)
      .size({ width: this.mViewData.bindSheetWidth, height: this.mBindSheetHeight })
      .gesture(PanGesture().onActionStart(() => {
        // 设置手势拦截，UEC外部组件不响应滚动
        log.showInfo('UIExtensionComponent PanGesture onAction');
      }))
  }

  build() {
    Stack()
      .id(`${TAG}_Stack`)
      .position({ x: 0, y: 0 })
      .bindSheet(this.mEditSecPageShow, this.formEditSecPageBuilder(), {
        width: this.mViewData.bindSheetWidth,
        height: this.mViewData.bindSheetHeight,
        showClose: true,
        dragBar: false,
        blurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
        backgroundColor: Color.Transparent,
        detents: [this.mBindSheetHeight, 0],
        mode: SheetMode.EMBEDDED,
        preferType: this.mViewData.sheetType,
        onAppear: () => {
          log.showWarn('form edit onAppear');
        },
        onWillDisappear: () => {
          log.showInfo('form edit will disappear.');
          this.mEditSecPageShow = false;
          this.mFormEditViewManager.openFormEditView();
        },
        onDisappear: () => {
          log.showWarn('form edit onDisappear');
        }
      })
  }
}