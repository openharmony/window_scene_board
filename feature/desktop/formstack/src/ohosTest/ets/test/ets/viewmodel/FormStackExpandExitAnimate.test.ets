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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
} from '@ohos/hypium';
import { FormStackDebugCmd } from '../../../../../main/ets/common/FormStackDebugCmd';
import { FormStackItemInfo } from '../../../../../../src/main/ets/common/FormStackItemInfo';
import { FormStackDataAdapt, FormStackMsg } from '../../../../../main/ets/common/FormStackDataAdapt';
import { FormStackExpandEvent } from '../../../../../main/ets/viewmodel/FormStackExpandEvent';
import { FormStackExpandViewData } from '../../../../../main/ets/viewmodel/FormStackExpandViewData';
import { FormStackExpandExitAnimate } from '../../../../../main/ets/viewmodel/FormStackExpandExitAnimate';
import { FormStackExpandCriticalAnimate } from '../../../../../main/ets/viewmodel/FormStackExpandCriticalAnimate';
import { OpenFormStackStateInfo } from '../../../../../main/ets/viewmodel/FormStackAnimateItem';
import { FormStackTestUtil } from '../common/FormStackTestUtil';

export function FormStackExpandExitAnimateTest() {
  describe('FormStackExpandExitAnimateTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('exitFormStackExpand', 0, () => {
      // 构建ViewData
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();

      // ViewEvent初始化
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let ret: boolean = expandEvent.initData(viewData, {});
      expect(ret).assertTrue();

      // 构建外部数据
      let formStackItemInfo: FormStackItemInfo =
        FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID);

      // 模拟外部展开事件
      FormStackDataAdapt.getInstance().handleMsg(FormStackMsg.SET_FORM_STACK_ITEM_INFO, formStackItemInfo);

      // 模拟点击空白区域，触发退出动画
      expandEvent.onBlankAreaClick();

      // ViewData状态数据校验
      expect(viewData.mVisible).assertFalse();
      expect(viewData.mBlurScale).assertEqual(0);
      expect(viewData.mHotAreaVisible).assertFalse();
      expect(viewData.mItemInfoList?.length === 0).assertTrue();
    });

    it('exitFormStackExpand_2', 0, () => {
      let criticalAnimate: FormStackExpandCriticalAnimate = new FormStackExpandCriticalAnimate();
      let exitAnimate: FormStackExpandExitAnimate = new FormStackExpandExitAnimate();
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(0);
      let openInfo: OpenFormStackStateInfo = FormStackTestUtil.createOpenFormStackStateInfo();
      expect(exitAnimate.exitFormStackExpand(openInfo, {}, true) === undefined).assertTrue();
      exitAnimate.initData(viewData, criticalAnimate);
      expect(exitAnimate.exitFormStackExpand(openInfo, {}, true) === undefined).assertTrue();
      expect(exitAnimate.resetData() === undefined).assertTrue();
      viewData = FormStackTestUtil.createFormStackExpandViewData(4);
      exitAnimate.initData(viewData, criticalAnimate);

      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackDebugCmd,
        FormStackDebugCmd.getInstance);
      when(mockFunc)().afterReturn({
        isNeedExpandAnimate () {
          return false;
        }
      });
      expect(exitAnimate.exitFormStackExpand(openInfo, {}, true) === undefined).assertTrue();
      mocker.clear(FormStackDebugCmd);
      mocker.clearAll();
    });


    it('exitFormStackExpand_3', 0, () => {
      let criticalAnimate: FormStackExpandCriticalAnimate = new FormStackExpandCriticalAnimate();
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(4);
      let openInfo: OpenFormStackStateInfo = FormStackTestUtil.createOpenFormStackStateInfo();
      let exitAnimate: FormStackExpandExitAnimate = new FormStackExpandExitAnimate();
      exitAnimate.initData(viewData, criticalAnimate);
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackDebugCmd,
        FormStackDebugCmd.getInstance);
      when(mockFunc)().afterReturn({
        isNeedExpandAnimate () {
          return true;
        }
      });
      expect(exitAnimate.exitFormStackExpand(openInfo, {}, false) === undefined).assertTrue();
      expect(exitAnimate.exitFormStackExpand(openInfo, {}, true) === undefined).assertTrue();
      mocker.clear(FormStackDebugCmd);
      mocker.clearAll();
    })

    it('exitFormStackExpand_4', 0, () => {
      let criticalAnimate: FormStackExpandCriticalAnimate = new FormStackExpandCriticalAnimate();
      let openInfo: OpenFormStackStateInfo = FormStackTestUtil.createOpenFormStackStateInfo();
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(4);
      let exitAnimate: FormStackExpandExitAnimate = new FormStackExpandExitAnimate();
      exitAnimate.initData(viewData, criticalAnimate);
      expect((exitAnimate as object)['presetMaskWhenClosing'](openInfo, null) === undefined).assertTrue();
      expect((exitAnimate as object)['presetMaskWhenClosing'](openInfo, criticalAnimate) === undefined).assertTrue();
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(criticalAnimate,
        criticalAnimate.initFormStackExpandCriticalParam);
      when(mockFunc)().afterReturn(true);
      expect((exitAnimate as object)['presetMaskWhenClosing'](openInfo, criticalAnimate) === undefined).assertTrue();
      mocker.clear(criticalAnimate);
      mocker.clearAll();
    })

    it('exitFormStackExpand_5', 0, () => {
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(3);
      let exitAnimate: FormStackExpandExitAnimate = new FormStackExpandExitAnimate();
      expect((exitAnimate as object)['setFormStackEditMask']('', viewData.mItemInfoList) === undefined).assertTrue();
    })
  });
}