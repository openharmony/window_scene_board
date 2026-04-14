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

import { Log } from '../aigcServiceAbility/IdlService/Log';
import { AigcParams } from '../uiability/AigcAbility';

const TAG: string = '[AigcService]AigcHome';

@Entry
@Component
struct AigcHome {
  @Provide('pageInfos') public pageInfos: NavPathStack = new NavPathStack();
  @Provide('isShowThemeDetail') isShowThemeDetail: boolean = false;
  @Provide('isPersonalizeShow') isPersonalizeShow: boolean = false;
  @Provide('isThemeDetailLoading') isThemeDetailLoading: boolean = false;
  @Provide('isFullScreen') isFullScreen: boolean = false;
  @Provide('isShowPandoraEditor') isShowPandoraEditor: boolean = false;
  @Provide isComplainShow: boolean = false;
  @Builder
  public PageMap(name: string) {
  }

  public aboutToAppear() {
    Log.info(TAG, `aboutToAppear`);
    let params: AigcParams | undefined =
      LocalStorage.getShared()?.get<AigcParams>('params');
    let startMode: number = params?.startMode as number;
    let editorId: string = params?.editorId as string;
    let status: number = params?.status as number;
    let errCode: number = params?.errCode as number;
    let pushPathName: string = params?.pushPathName as string;

    const aigcParams: AigcParams = {
      startMode: startMode,
      editorId: editorId,
      status: status,
      errCode: errCode
    };
    this.pageInfos.pushPath({ name: pushPathName, param: aigcParams }, false);
  }

  public aboutToDisappear() {
    // displayHelper.destroy();
  }

  public build() {
    Navigation(this.pageInfos) {
    }
    .id('AigcHome')
    .key('AigcHome')
    .backgroundColor(Color.Transparent)
    .hideTitleBar(true)
    .navDestination(this.PageMap)
    .mode(NavigationMode.Stack)
  }
}