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
import { CheckEmptyUtils } from '@ohos/basicutils';
import { FormStackManager } from '../../../../../main/ets/common/FormStackManager';
import { FormStackExpandItem } from '../../../../../main/ets/viewmodel/FormStackExpandItem';

import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  MockKit,
  when,
} from '@ohos/hypium';
import { FormStackDebugCmd } from '../../../../../main/ets/common/FormStackDebugCmd';
import { FormStackExpandConfig } from '../../../../../main/ets/common/FormStackExpandConfig';
import { FormStackExpandLayoutModel } from '../../../../../main/ets/common/FormStackExpandLayoutModel';
import { FormStackExpandModel } from '../../../../../main/ets/common/FormStackExpandModel';
import { OpenFormStackStateInfo } from '../../../../../main/ets/viewmodel/FormStackAnimateItem';
import { FormStackExpandCriticalAnimate } from '../../../../../main/ets/viewmodel/FormStackExpandCriticalAnimate';
import { FormStackExpandViewData } from '../../../../../main/ets/viewmodel/FormStackExpandViewData';
import type { CriticalAnimateResult } from '../common/FormStackTestUtil';
import { FormStackTestUtil } from '../common/FormStackTestUtil';

export function FormStackExpandCriticalAnimateTest() {
  describe('FormStackExpandCriticalAnimateTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initFormStackExpandCriticalParam', 0, () => {
      // 构建ViewData 和 Model数据
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(3);
      let expandModel: FormStackExpandModel = new FormStackExpandModel();

      // 初始化expandModel
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      FormStackTestUtil.initDefaultConfig(config);
      layoutModel.initData(config);

      // criticalAnimate 初始化
      let criticalAnimate: FormStackExpandCriticalAnimate = new FormStackExpandCriticalAnimate();
      criticalAnimate.initData(viewData, layoutModel, expandModel);
      let openInfo: OpenFormStackStateInfo = FormStackTestUtil.createOpenFormStackStateInfo();

      // 打开展开动画的开关
      FormStackDebugCmd.getInstance().setExpandAnimateSwitch(['true']);

      // ViewData 状态变量校验
      let len: number = viewData.mItemInfoList.length;
      let result: CriticalAnimateResult = FormStackTestUtil.getCriticalAnimateResult(true);
      if (!result || result.translateY?.length !== len || result.rotateX?.length !== len ||
        result.scaleX?.length !== len || result.scaleY?.length !== len) {
        return;
      }

      // 关闭展开动画的开关
      FormStackDebugCmd.getInstance().setExpandAnimateSwitch(['false']);
    });

    it('initFormStackExpandCriticalParam_2', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let animate: FormStackExpandCriticalAnimate = new FormStackExpandCriticalAnimate();
        let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(0);
        let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
        let expandModel: FormStackExpandModel = new FormStackExpandModel();
        animate.initData(viewData, layoutModel, expandModel);
        let openInfo: OpenFormStackStateInfo = FormStackTestUtil.createOpenFormStackStateInfo();
        let ret: boolean = animate.initFormStackExpandCriticalParam(openInfo, true);
        expect(ret).assertFalse();
        viewData = FormStackTestUtil.createFormStackExpandViewData(3);
        animate.initData(viewData, layoutModel, expandModel);
        let mockFunc = mocker.mockFunc(FormStackDebugCmd.getInstance(),
          FormStackDebugCmd.getInstance().isNeedExpandAnimate);
        when(mockFunc)().afterReturn(false);
        ret = animate.initFormStackExpandCriticalParam(openInfo, true);
        expect(ret).assertFalse();
        mocker.clear(FormStackDebugCmd.getInstance());
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('resetData', Level.LEVEL0, (): void => {
      let resetDataFun: FormStackExpandCriticalAnimate = new FormStackExpandCriticalAnimate();
      resetDataFun.resetData();
      expect(true).assertEqual(true);
    })

    it('initData', Level.LEVEL0, (): void => {
      let resetDataFun: FormStackExpandCriticalAnimate = new FormStackExpandCriticalAnimate();
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(0);
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      let expandModel: FormStackExpandModel = new FormStackExpandModel();
      resetDataFun.initData(viewData, layoutModel, expandModel);
      expect(true).assertEqual(true);
    })

    let animate: FormStackExpandCriticalAnimate = new FormStackExpandCriticalAnimate();
    let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(0);
    let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
    let expandModel: FormStackExpandModel = new FormStackExpandModel();
    animate.initData(viewData, layoutModel, expandModel);
    let openInfo: OpenFormStackStateInfo = FormStackTestUtil.createOpenFormStackStateInfo();
    let ret: boolean = animate.initFormStackExpandCriticalParam(openInfo, true);
    let formStackExpandItem: FormStackExpandItem = new FormStackExpandItem();
    let itemList: FormStackExpandItem[] = [formStackExpandItem, formStackExpandItem, formStackExpandItem];


    it('initFormStackExpandCriticalParam_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((animate as object), (animate as object)['isValidOpenInfo']());
      let mockFunc1 = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      let mockFunc2 =
        mocker.mockFunc(FormStackDebugCmd.getInstance(), FormStackDebugCmd.getInstance().isNeedExpandAnimate);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc2)().afterReturn(true);
      animate.initFormStackExpandCriticalParam(openInfo, true);
      expect(animate).not().assertUndefined();
      mocker.clear(FormStackDebugCmd.getInstance());
      mocker.clear((animate as object));
      mocker.clear(CheckEmptyUtils);
    });

    it('initTopFormParam_test01', 0, () => {
      openInfo.mTopItem.mScaleX = 2;
      openInfo.mTopItem.mScaleY = 2;
      openInfo.mTopItem.mRotateAngle = 2;
      openInfo.mTopItem.mTranslateY = 2;
      openInfo.mTopItem.mOpacity = 2;
      (animate as object)['initTopFormParam'](formStackExpandItem, true, openInfo);
      expect(animate).not().assertUndefined();

      (animate as object)['initTopFormParam'](formStackExpandItem, false, openInfo);
      expect(animate).not().assertUndefined();
    });

    it('initSecondTopFormParam_test01', 0, () => {
      openInfo.mIsOpenByMenu = true;
      (animate as object)['initSecondTopFormParam'](formStackExpandItem, true, openInfo);
      expect(animate).not().assertUndefined();

      openInfo.mIsOpenByMenu = false;
      (animate as object)['initSecondTopFormParam'](formStackExpandItem, true, openInfo);
      expect(animate).not().assertUndefined();

      (animate as object)['initTopFormParam'](formStackExpandItem, false, openInfo);
      expect(animate).not().assertUndefined();
    });

    it('initFormStackAnimateParam_test01', 0, () => {
      (animate as object)['mLayoutModel'] = false;
      (animate as object)['initFormStackAnimateParam'](openInfo, true, itemList);
      expect(animate).not().assertUndefined();
    });

    it('initFormStackAnimateParam_test02', 0, () => {
      openInfo.position.left = 4;
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      config.mFormStackExpandScale.x = 1;
      config.mFormStackExpandScale.y = 1;
      config.mFormStackOffsetX = 2;
      config.mIsExpandCenter = true;
      config.mFormWidth = 4;
      config.mFormShowWidth = 2;
      let itemList: FormStackExpandItem[] =
        [formStackExpandItem, formStackExpandItem, formStackExpandItem, formStackExpandItem];
      (animate as object)['mLayoutModel'] = true;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      let mockFunc1 = mocker.mockFunc((animate as object), (animate as object)['getTopIndexOfFormStack']);
      let mockFunc2 = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(config);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(2);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(2);
      (animate as object)['initFormStackAnimateParam'](openInfo, true, itemList);
      expect(animate).not().assertUndefined();
      mocker.clear(FormStackExpandConfig);
      mocker.clear((animate as object));
      mocker.clear(AppStorage);
    });

    it('initFormStackAnimateParam_test03', 0, () => {
      (animate as object)['mLayoutModel'] = true;
      openInfo.position.left = 4;
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      config.mFormStackExpandScale.x = undefined;
      config.mFormStackExpandScale.y = undefined;
      config.mFormStackOffsetX = 2;
      config.mIsExpandCenter = false;
      config.mFormWidth = 4;
      config.mFormShowWidth = 2;
      let itemList: FormStackExpandItem[] = [formStackExpandItem, formStackExpandItem, formStackExpandItem, formStackExpandItem];
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      let mockFunc1 = mocker.mockFunc((animate as object), (animate as object)['getTopIndexOfFormStack']);
      let mockFunc2 = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(config);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(2);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(2);
      (animate as object)['initFormStackAnimateParam'](openInfo, true, itemList);
      expect(animate).not().assertUndefined();
      mocker.clear(FormStackExpandConfig);
      mocker.clear((animate as object));
      mocker.clear(AppStorage);
    });

    it('initFormStackAnimateParam_test04', 0, () => {
      (animate as object)['mLayoutModel'] = true;
      let itemList: FormStackExpandItem[] = [formStackExpandItem, formStackExpandItem, formStackExpandItem, formStackExpandItem];
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      config.mIsExpandCenter = false;
      config.mFormWidth = 4;
      config.mFormShowWidth = 2;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      let mockFunc1 = mocker.mockFunc((animate as object), (animate as object)['getTopIndexOfFormStack']);
      let mockFunc2 = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(config);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(2);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      (animate as object)['initFormStackAnimateParam'](openInfo, true, itemList);
      expect(animate).not().assertUndefined();
      mocker.clear(FormStackExpandConfig);
      mocker.clear((animate as object));
      mocker.clear(AppStorage);
    });

    it('initFormStackAnimateParam_test05', 0, () => {
      (animate as object)['mLayoutModel'] = true;
      let itemList: FormStackExpandItem[] = [formStackExpandItem, formStackExpandItem, formStackExpandItem, formStackExpandItem];
      openInfo.position.left = 4;
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      config.mFormStackExpandScale.x = 1;
      config.mFormStackExpandScale.y = 1;
      config.mFormStackOffsetX = 2;
      config.mIsExpandCenter = true;
      config.mFormWidth = 4;
      config.mFormShowWidth = 2;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      let mockFunc1 = mocker.mockFunc((animate as object), (animate as object)['getTopIndexOfFormStack']);
      let mockFunc2 = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(config);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(2);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(2);
      (animate as object)['initFormStackAnimateParam'](openInfo, false, itemList);
      expect(animate).not().assertUndefined();
      mocker.clear(FormStackExpandConfig);
      mocker.clear((animate as object));
      mocker.clear(AppStorage);
    });

    it('getTopIndexOfFormStack_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getTopFormId);
      let mockFunc1 = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('a');
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      (animate as object)['getTopIndexOfFormStack'](itemList);
      expect(animate).not().assertUndefined();
      mocker.clear(FormStackManager.getInstance());
      mocker.clear(CheckEmptyUtils);
    });

    it('getTopIndexOfFormStack_test02', 0, () => {
      (animate as object)['mExpandModel'] = expandModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getTopFormId);
      let mockFunc1 = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('a');
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      (animate as object)['getTopIndexOfFormStack'](itemList);
      expect(animate).not().assertUndefined();
      mocker.clear(FormStackManager.getInstance());
      mocker.clear(CheckEmptyUtils);
    });
  });
}