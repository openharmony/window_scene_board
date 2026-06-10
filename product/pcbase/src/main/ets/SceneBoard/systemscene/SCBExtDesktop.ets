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

import { LogDomain, LogHelper, SingleContext, singleManager } from '@ohos/basicutils';
import { ViewArea, ViewType, EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { SCBScreenProperty } from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';
import PcRightMenuViewModel from '../../common/viewmodel/PcRightMenuViewModel';
import RightMenuOptionsCalc from '../../common/viewmodel/RightMenuOptionsCalc';
import RightMenu from '@ohos/launchercommon/src/main/ets/pagedesktop/components/RightMenu';
import { ShutDownDialog, RunningAppListState, SystemShutdownStyle } from '@ohos/shutdownview';
import lazy { PublishExtShutdownEvent } from '@ohos/shutdownview';

const TAG = 'SCBExtDesktop';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const RIGHT_MENU_KEY = 'h2_launcher_feature_pagedesktop_rightMenu';

@Component
export struct SCBExtDesktop {
  @Link @Watch('onscreenPropChange') screenProp: SCBScreenProperty;
  @State singleContext?: SingleContext = { extendScreenId: this.screenProp.screenId };
  @State viewController: BaseViewController = new BaseViewController(ViewType.DESKTOP_EXT, this.screenProp.screenId)
  persistentId : number = 0;
  private rightMenuOptionsCalc = new RightMenuOptionsCalc();
  private rightMenuViewModel: PcRightMenuViewModel =  new PcRightMenuViewModel({ extendScreenId: this.screenProp.screenId });
  private eventMgr: EventManager = EvtBus.createEventManager();
  @State dlgHeight: number = SystemShutdownStyle.confirmDialogMaxHeight;
  @State runningAppList: RunningAppListState[] = [];
  @State isReboot: boolean = false;
  @State isHibernate: boolean = true;
  dialogController: CustomDialogController = new CustomDialogController({
    builder: ShutDownDialog({
      runningAppList: this.runningAppList,
      dlgHeight: this.dlgHeight,
      isReboot: this.isReboot,
      isHibernate: this.isHibernate
    }),
    showInSubWindow: true,
    customStyle: true,
    maskColor: Color.Transparent,
    autoCancel: false
  })

  private initRightMenuViewModel(): void {
    this.rightMenuViewModel.setRightMenuOptionsCalc(this.rightMenuOptionsCalc);
  }

  private onscreenPropChange(): void {
    let area: ViewArea = {
      left: 0,
      top: 0,
      width: px2vp(this.screenProp?.width),
      height: px2vp(this.screenProp?.height)
    }
    this.viewController.updateRect(area);
  }

  private extShutdownDialogOpen = (event: PublishExtShutdownEvent): void => {
    if (event.state === true) {
      log.showInfo('extShutdownDialogOpen start');
      this.dlgHeight = event.dlgHeight;
      this.runningAppList = event.runningAppList;
      this.isReboot = event.isReboot;
      this.isHibernate = event.isHibernate;
      this.dialogController.open();
    }
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.viewController.updateId(this.persistentId);
    this.viewController.show();
    this.initRightMenuViewModel();
    this.eventMgr.on(PublishExtShutdownEvent, this.extShutdownDialogOpen);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.eventMgr.offAll();
  }

  build() {
    Stack() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Stack() {
          Text()
            .defaultFocus(true)
            .focusable(true)
            .width('100%')
            .height('100%')
        }
        .bindContextMenu(this.RightMenuBuilder, ResponseType.RightClick, {
          backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR
        })
      }
      .width('100%')
      .height('100%')
    }
  }

  @Builder
  RightMenuBuilder() {
    RightMenu({
      rightMenuViewModel: this.rightMenuViewModel
    })
      .key(RIGHT_MENU_KEY)
  }
}