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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { StateEx } from '@ohos/componenthelper';
import { IconEditWantData } from '../../default/data/IconEditWantData';
import { EditModeExtensionData } from '../../default/data/EditModeExtensionData';
import { editModeViewManager } from '../../default/manager/EditModeViewManager';
import { editModeUIExtensionViewModel } from '../viewmodel/EditModeUIExtensionViewModel';
import { EditModeDockConstants } from '../../default/common/constants/EditModeStyleConstants';
import { launcherVisualEffectMgr } from '@ohos/launchercommon/Index';
import { Want } from '@kit.AbilityKit';

const TAG: string = 'EditModeExtensionUI';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面编辑UIExtension
 */
@Component
export default struct EditModeExtensionUI {
  @State iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
  @State editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
  @State uiOpacity: StateEx<number> = launcherVisualEffectMgr.getEditModeExtensionUIOpacity();

  build() {
    if (this.editModeExtensionData.isShowUIExtension()) {
      UIExtensionComponent(this.iconEditWantData.getExtensionWant())
        .id('edit_mode_extension_occlusion')
        .size({ width: '100%', height: '100%' })
        .opacity(this.uiOpacity.value)
        .onRemoteReady((proxy: UIExtensionProxy) => {
          editModeUIExtensionViewModel.initProxy(proxy);
          log.showInfo('onRemoteReady');
        })
        .onReceive((data: Record<string, object | string | number | boolean>) => {
          editModeUIExtensionViewModel.onReceiveData(data, this.iconEditWantData.getExtensionWant());
        })
        .onRelease((releaseCode: number) => {
          log.showInfo(`onRelease, code: ${releaseCode}`);
          editModeViewManager.exitUIExtension(false);
        })
        .onResult((data: Object) => {
          log.showInfo(`onResult}`);
          editModeViewManager.exitUIExtension(false);
        })
        .onError((error) => {
          log.showError('onError');
          editModeUIExtensionViewModel.initDesktopCache();
          editModeViewManager.exitUIExtension(false);
        })
        .onTerminated((info : TerminationInfo) => {
          log.info(`onTerminated, info.code = ${info?.code}`);
          editModeUIExtensionViewModel.initDesktopCache();
          editModeViewManager.exitUIExtension(false);
        })
        .onAppear(() => {
          focusControl.requestFocus('edit_mode_extension_occlusion');
          let want: Want | undefined = this.iconEditWantData.getExtensionWant()
          if (want?.abilityName === 'HomeThemeComponentExtAbility') {
            AppStorage.setOrCreate('showWallpaperPage', true)
          }
        })
        .onDisAppear(()=>{
          let want: Want | undefined = this.iconEditWantData.getExtensionWant()
          if (want?.abilityName === 'HomeThemeComponentExtAbility') {
            AppStorage.setOrCreate('showWallpaperPage', false)
          }
        })
    }
  }
}