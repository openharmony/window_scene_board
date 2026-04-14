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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { screenLockSysFloatTipControl ,SysFloatTipCallback} from '@ohos/screenlockcommon/src/main/ets/manager/SysFloatTipController';

function setTipMessage(tipMessage: string){

}
function setTipMarginBottom(tipMarginBottom: number){

}
function setSysFloatTipDialogVisible(isShowDialog: boolean){

}
function getComponentId(): string{
return 'new'
}
let add:SysFloatTipCallback  = {

  setTipMessage:setTipMessage,

  setTipMarginBottom: setTipMarginBottom,

  setSysFloatTipDialogVisible: setSysFloatTipDialogVisible,

  getComponentId: getComponentId,
}
export default function SysFloatTipControllerTest() {
  describe('SysFloatTipControllerTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_RegisterCallback_return', 0, (): void => {

      screenLockSysFloatTipControl.registerCallback(add);

      screenLockSysFloatTipControl.unRegisterCallback(add);

      let componentId:string = '';
      let tipMessage:string = 'one';
      screenLockSysFloatTipControl.setTipMessage(componentId,tipMessage);
      let componentId1:string = '';
      let tipMessage1:string = '';
      screenLockSysFloatTipControl.setTipMessage(componentId1,tipMessage1);
      let componentId2:string = '';
      let tipMarginBottom:number = 1;
      screenLockSysFloatTipControl.setTipMarginBottom(componentId2,tipMarginBottom);
      expect(tipMarginBottom).assertEqual(1);

    })
    it('test_setFloatTipDialogVisible_return', 0, (): void => {
      let SYS_TIP_DIALOG_DURATION = 2000;
      let componentId:string = '';
      let isShow:boolean = false;
      let duration: number = SYS_TIP_DIALOG_DURATION;
      screenLockSysFloatTipControl.setFloatTipDialogVisible(componentId,isShow,duration);
      let componentId1:string = 'one';
      screenLockSysFloatTipControl.setFloatTipDialogVisible(componentId1,isShow,duration);
      let isShow1:boolean = true;
      screenLockSysFloatTipControl.setFloatTipDialogVisible(componentId1,isShow1,duration);
      expect(isShow1).assertEqual(true);

    })
  })
}