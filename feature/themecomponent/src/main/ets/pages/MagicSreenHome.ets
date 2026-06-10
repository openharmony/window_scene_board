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
import { Log } from "../aigcServiceAbility/IdlService/Log";

const TAG: string = 'MagicScreenHome';
export const MAGIC_SCREEN: string = 'magicScreenHome';

@Component
export struct MagicScreenHome {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @State contentWidth: number = 0;
  // private params: WantParams | undefined = undefined;
  private params: ESObject | undefined = undefined;

  build() {
    NavDestination() {
      UIExtensionComponent({
        bundleName: 'com.ohos.sceneboard',
        abilityName: 'MagicScreenExtensionAbility',
        parameters: {
          'ability.want.params.uiExtensionType': 'sys/commonUI',
          'nav': 'magicScreen',
          'isFull': false,
          'source': 'settings'
        }
      })
        .height('100%')
        .width('100%')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP])
        .onError((error) => {
          Log.info(TAG, `UIExtensionComponent onError code: ${error?.code} message: ${error?.message}`);
        })
        .onReceive((data) => {
          this.onReceiveData(data);
        });
    }
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .onShown(async () => {
      this.onPageShow();
    })
    .onHidden(() => {
      this.onPageHide();
    })
  }

  onReceiveData(data: object): void {
    Log.info(TAG, `data = ${JSON.stringify(data)}`);
    if (data && data['back'] === true) {
      if (this.pageInfos?.size() <= 1) {
        try {
          // NavigationUtil.doPageBack();
        } catch (err) {
          Log.error(TAG, `send back Msg error: ${err?.code}`);
        }
      } else {
        this.pageInfos.pop();
      }
    }
    if (data && data['themeFullScreen'] !== undefined) {
      try {
        let isFull: boolean = data['themeFullScreen'] as boolean;
        // NavigationUtil.session?.sendData({ 'themeFullScreen': isFull ? true : false });
      } catch (err) {
        Log.error(TAG, `send themeFullScreen Msg error: ${err?.code}`);
      }
    }
  }

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear`);
    // const want: WantParams[] = this.pageInfos.getParamByName(MAGIC_SCREEN) as WantParams[];
    const want: ESObject[] = this.pageInfos.getParamByName(MAGIC_SCREEN) as ESObject[];
    if (want && want?.length > 0) {
      // let param: WantParams = want[0];
      let param: ESObject = want[0];
      if (!param) {
        Log.error(TAG, 'param is null');
        return;
      }
      if (param.session) {
        // NavigationUtil.session = param.session;
      }
      this.params = {
        editorId: param.editorId,
        themeName: param.themeName
      };
      Log.info(TAG, `editorId = ${param.editorId}`);
    }
  }

  aboutToDisappear(): void {
    Log.info(TAG, `aboutToDisappear`);
  }

  onPageShow(): void {
    Log.info(TAG, `onPageShow`);
  }

  onPageHide(): void {
    Log.info(TAG, `onPageHide`);
  }
}