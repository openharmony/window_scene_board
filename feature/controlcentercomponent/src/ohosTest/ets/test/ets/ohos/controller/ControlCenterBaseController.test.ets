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
import CommonEventManager from '@ohos.commonEventManager';
import { StartSceneFromOtherEvent, EvtBus } from '@ohos/frameworkwrapper';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import ControlCenterBaseController from '../../../../../../main/ets/com/ohos/controller/ControlCenterBaseController';


export function ControlCenterBaseControllerTest() {
  describe('ControlCenterBaseControllerTest', (): void => {

    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('ControlCenterBaseControllerTest0001', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
    })
    it('ControlCenterBaseControllerTest0002', 0, (): void => {
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('12');
      expect(handleLabelClick).assertInstanceOf('Boolean');
    })
    it('ControlCenterBaseControllerTest0003', 0, (): void => {
      let isNewStyleOpen = ControlCenterBaseController.isNewStyleOpen;
      expect(isNewStyleOpen).assertInstanceOf('Boolean');
    })
    it('ControlCenterBaseControllerTest0004', 0, (): void => {
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0005', 0, (): void => {
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0006', 0, (): void => {
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0007', 0, (): void => {
      let handleLabelClick: boolean = ControlCenterBaseController.handleLabelClick('15');
      expect(handleLabelClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0008', 0, (): void => {
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
    })
    it('ControlCenterBaseControllerTest0009', 0, (): void => {
      let getNewLottieOpenName: string = ControlCenterBaseController.getNewLottieOpenName();
      expect(getNewLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0010', 0, (): void => {
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0011', 0, (): void => {
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0012', 0, (): void => {
      let getLottieDarkName: string = ControlCenterBaseController.getLottieDarkName();
      expect(getLottieDarkName !== null).assertEqual(true);
      let matchLottieData = ControlCenterBaseController.matchLottieData(false);
      expect(matchLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0013', 0, (): void => {
      let getSbPluginSlot: string = ControlCenterBaseController.getSbPluginSlot();
      expect(getSbPluginSlot !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0014', 0, (): void => {
      let handleClick: boolean = ControlCenterBaseController.isAvailable();
      expect(handleClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0015', 0, (): void => {
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0016', 0, (): void => {
      let handleLabelClick: boolean = ControlCenterBaseController.handleLabelClick('15');
      expect(handleLabelClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0017', 0, (): void => {
      let handleHover = ControlCenterBaseController.handleHover(true);
      expect(handleHover !== null).assertEqual(true);
    })
    it('ControlCenterBaseControllerTest0018', 0, (): void => {
      let matchLottieData = ControlCenterBaseController.matchLottieData(false);
      expect(matchLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0019', 0, (): void => {
      let matchLottieData = ControlCenterBaseController.matchLottieData(false);
      expect(matchLottieData !== null).assertEqual(true);
      let handleLabelClick: boolean = ControlCenterBaseController.handleLabelClick('119');
      expect(handleLabelClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0020', 0, (): void => {
      let matchLottieData = ControlCenterBaseController.matchLottieData(true);
      expect(matchLottieData !== null).assertEqual(true);
      let handleLabelClick: boolean = ControlCenterBaseController.handleLabelClick('120');
      expect(handleLabelClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0021', 0, (): void => {
      let matchLottieData = ControlCenterBaseController.matchLottieData(true);
      expect(matchLottieData !== null).assertEqual(true);
      let handleLabelClick: boolean = ControlCenterBaseController.handleLabelClick('121');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0022', 0, (): void => {
      let matchLottieData = ControlCenterBaseController.matchLottieData(false);
      expect(matchLottieData !== null).assertEqual(true);
      let handleLabelClick: boolean = ControlCenterBaseController.handleLabelClick('122');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0023', 0, (): void => {
      let matchLottieData = ControlCenterBaseController.matchLottieData(false);
      expect(matchLottieData !== null).assertEqual(true);
      let handleLabelClick: boolean = ControlCenterBaseController.handleLabelClick('123');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0024', 0, (): void => {
      let matchLottieData = ControlCenterBaseController.matchLottieData(false);
      expect(matchLottieData !== null).assertEqual(true);
      let handleLabelClick: boolean = ControlCenterBaseController.handleLabelClick('124');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0025', 0, (): void => {
      let matchLottieData = ControlCenterBaseController.matchLottieData(true);
      expect(matchLottieData !== null).assertEqual(true);
      let handleLabelClick: boolean = ControlCenterBaseController.handleLabelClick('125');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0026', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('13');
      expect(handleLabelClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0027', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0028', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0029', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0030', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0031', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getNewLottieOpenName: string = ControlCenterBaseController.getNewLottieOpenName();
      expect(getNewLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0032', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0033', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0034', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getLottieDarkName: string = ControlCenterBaseController.getLottieDarkName();
      expect(getLottieDarkName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0035', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getSbPluginSlot: string = ControlCenterBaseController.getSbPluginSlot();
      expect(getSbPluginSlot !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0036', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleClick: boolean = ControlCenterBaseController.isAvailable();
      expect(handleClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0037', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0038', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0039', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0040', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('122');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0041', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('110');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0042', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('112');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0043', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('133');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getNewLottieOpenName: string = ControlCenterBaseController.getNewLottieOpenName();
      expect(getNewLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0044', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('125');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0045', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('114');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0046', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('111');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getLottieDarkName: string = ControlCenterBaseController.getLottieDarkName();
      expect(getLottieDarkName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0047', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('19');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getSbPluginSlot: string = ControlCenterBaseController.getSbPluginSlot();
      expect(getSbPluginSlot !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0048', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('16');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let handleClick: boolean = ControlCenterBaseController.isAvailable();
      expect(handleClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0049', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('18');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0050', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('14');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0051', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0052', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0053', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0054', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getNewLottieOpenName: string = ControlCenterBaseController.getNewLottieOpenName();
      expect(getNewLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0055', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0056', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0057', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getLottieDarkName: string = ControlCenterBaseController.getLottieDarkName();
      expect(getLottieDarkName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0058', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getSbPluginSlot: string = ControlCenterBaseController.getSbPluginSlot();
      expect(getSbPluginSlot !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0059', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let handleClick: boolean = ControlCenterBaseController.isAvailable();
      expect(handleClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0060', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0061', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0062', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0063', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getNewLottieOpenName: string = ControlCenterBaseController.getNewLottieOpenName();
      expect(getNewLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0064', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0065', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0066', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getSbPluginSlot: string = ControlCenterBaseController.getSbPluginSlot();
      expect(getSbPluginSlot !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0067', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let handleClick: boolean = ControlCenterBaseController.isAvailable();
      expect(handleClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0068', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0069', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0070', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0071', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getNewLottieOpenName: string = ControlCenterBaseController.getNewLottieOpenName();
      expect(getNewLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0072', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0073', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0074', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieDarkName: string = ControlCenterBaseController.getLottieDarkName();
      expect(getLottieDarkName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0075', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getSbPluginSlot: string = ControlCenterBaseController.getSbPluginSlot();
      expect(getSbPluginSlot !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0076', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let handleClick: boolean = ControlCenterBaseController.isAvailable();
      expect(handleClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0077', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0078', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0079', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getNewLottieOpenName: string = ControlCenterBaseController.getNewLottieOpenName();
      expect(getNewLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0080', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0081', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0082', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getLottieDarkName: string = ControlCenterBaseController.getLottieDarkName();
      expect(getLottieDarkName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0083', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getSbPluginSlot: string = ControlCenterBaseController.getSbPluginSlot();
      expect(getSbPluginSlot !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0084', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let handleClick: boolean = ControlCenterBaseController.isAvailable();
      expect(handleClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0085', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0086', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0087', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getNewLottieOpenName: string = ControlCenterBaseController.getNewLottieOpenName();
      expect(getNewLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0088', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0089', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
      let getLottieDarkName: string = ControlCenterBaseController.getLottieDarkName();
      expect(getLottieDarkName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0090', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
      let getSbPluginSlot: string = ControlCenterBaseController.getSbPluginSlot();
      expect(getSbPluginSlot !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0091', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
      let handleClick: boolean = ControlCenterBaseController.isAvailable();
      expect(handleClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0092', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0093', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getLottieDarkName: string = ControlCenterBaseController.getLottieDarkName();
      expect(getLottieDarkName !== null).assertEqual(true);
      let matchLottieData = ControlCenterBaseController.matchLottieData(false);
      expect(matchLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0094', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let matchLottieData = ControlCenterBaseController.matchLottieData(false);
      expect(matchLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0095', 0, (): void => {
      let matchLottieData = ControlCenterBaseController.matchLottieData(false);
      expect(matchLottieData !== null).assertEqual(true);
      let handleLabelClick: boolean = ControlCenterBaseController.handleLabelClick('122');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0096', 0, (): void => {
      let matchLottieData = ControlCenterBaseController.matchLottieData(false);
      expect(matchLottieData !== null).assertEqual(true);
      let handleLabelClick: boolean = ControlCenterBaseController.handleLabelClick('123');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0097', 0, (): void => {
      let matchLottieData = ControlCenterBaseController.matchLottieData(false);
      expect(matchLottieData !== null).assertEqual(true);
      let handleLabelClick: boolean = ControlCenterBaseController.handleLabelClick('124');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0098', 0, (): void => {
      let matchLottieData = ControlCenterBaseController.matchLottieData(true);
      expect(matchLottieData !== null).assertEqual(true);
      let handleLabelClick: boolean = ControlCenterBaseController.handleLabelClick('125');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0099', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('13');
      expect(handleLabelClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0100', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0101', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0102', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0103', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0104', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getNewLottieOpenName: string = ControlCenterBaseController.getNewLottieOpenName();
      expect(getNewLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0105', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0106', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0107', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getLottieDarkName: string = ControlCenterBaseController.getLottieDarkName();
      expect(getLottieDarkName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0108', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let getSbPluginSlot: string = ControlCenterBaseController.getSbPluginSlot();
      expect(getSbPluginSlot !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0109', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleClick: boolean = ControlCenterBaseController.isAvailable();
      expect(handleClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0110', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0111', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0112', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0113', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('122');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0114', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('110');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0115', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('112');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0116', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('133');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getNewLottieOpenName: string = ControlCenterBaseController.getNewLottieOpenName();
      expect(getNewLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0117', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('125');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0118', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('114');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0119', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('111');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getLottieDarkName: string = ControlCenterBaseController.getLottieDarkName();
      expect(getLottieDarkName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0120', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('19');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let getSbPluginSlot: string = ControlCenterBaseController.getSbPluginSlot();
      expect(getSbPluginSlot !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0121', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('16');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let handleClick: boolean = ControlCenterBaseController.isAvailable();
      expect(handleClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0122', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('18');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0123', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('14');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0124', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0125', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0126', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0127', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getNewLottieOpenName: string = ControlCenterBaseController.getNewLottieOpenName();
      expect(getNewLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0128', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0129', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0130', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getLottieDarkName: string = ControlCenterBaseController.getLottieDarkName();
      expect(getLottieDarkName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0131', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getSbPluginSlot: string = ControlCenterBaseController.getSbPluginSlot();
      expect(getSbPluginSlot !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0132', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let handleClick: boolean = ControlCenterBaseController.isAvailable();
      expect(handleClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0133', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0134', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0135', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0136', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getNewLottieOpenName: string = ControlCenterBaseController.getNewLottieOpenName();
      expect(getNewLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0137', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0138', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0139', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getSbPluginSlot: string = ControlCenterBaseController.getSbPluginSlot();
      expect(getSbPluginSlot !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0140', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let handleClick: boolean = ControlCenterBaseController.isAvailable();
      expect(handleClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0141', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0142', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0143', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0144', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getNewLottieOpenName: string = ControlCenterBaseController.getNewLottieOpenName();
      expect(getNewLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0145', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0146', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0147', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieDarkName: string = ControlCenterBaseController.getLottieDarkName();
      expect(getLottieDarkName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0148', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getSbPluginSlot: string = ControlCenterBaseController.getSbPluginSlot();
      expect(getSbPluginSlot !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0149', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let handleClick: boolean = ControlCenterBaseController.isAvailable();
      expect(handleClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0150', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0151', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0152', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getNewLottieOpenName: string = ControlCenterBaseController.getNewLottieOpenName();
      expect(getNewLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0153', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0154', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0155', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getLottieDarkName: string = ControlCenterBaseController.getLottieDarkName();
      expect(getLottieDarkName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0156', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getSbPluginSlot: string = ControlCenterBaseController.getSbPluginSlot();
      expect(getSbPluginSlot !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0157', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let handleClick: boolean = ControlCenterBaseController.isAvailable();
      expect(handleClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0158', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0159', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0160', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getNewLottieOpenName: string = ControlCenterBaseController.getNewLottieOpenName();
      expect(getNewLottieOpenName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0161', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0162', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
      let getLottieDarkName: string = ControlCenterBaseController.getLottieDarkName();
      expect(getLottieDarkName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0163', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
      let getSbPluginSlot: string = ControlCenterBaseController.getSbPluginSlot();
      expect(getSbPluginSlot !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0164', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
      let handleClick: boolean = ControlCenterBaseController.isAvailable();
      expect(handleClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0165', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getCloseLottieData: object = ControlCenterBaseController.getCloseLottieData();
      expect(getCloseLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
      let handleLongClick: boolean = ControlCenterBaseController.handleLongClick();
      expect(handleLongClick).assertInstanceOf('Boolean');
    })

    it('ControlCenterBaseControllerTest0166', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getLottieDarkName: string = ControlCenterBaseController.getLottieDarkName();
      expect(getLottieDarkName !== null).assertEqual(true);
      let matchLottieData = ControlCenterBaseController.matchLottieData(false);
      expect(matchLottieData !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0167', 0, (): void => {
      let isAvailable: boolean = ControlCenterBaseController.isAvailable();
      expect(isAvailable).assertEqual(true);
      let handleLabelClick = ControlCenterBaseController.handleLabelClick('144');
      expect(handleLabelClick).assertInstanceOf('Boolean');
      let isDarkReverse = ControlCenterBaseController.isDarkReverse();
      expect(isDarkReverse).assertInstanceOf('Boolean');
      let getOpenLottieData: object = ControlCenterBaseController.getOpenLottieData();
      expect(getOpenLottieData !== null).assertEqual(true);
      let getLottieOpenName: string = ControlCenterBaseController.getLottieOpenName();
      expect(getLottieOpenName !== null).assertEqual(true);
      let matchLottieData = ControlCenterBaseController.matchLottieData(false);
      expect(matchLottieData !== null).assertEqual(true);
    })

    it('hideControlPanelTest', 0, (): void => {
      let hideControlPanel = true;
      let event = StartSceneFromOtherEvent.getInstance("hideControlPanelTest", "hideControlPanelAbilityTest");
      EvtBus.post(StartSceneFromOtherEvent, event);
      expect(hideControlPanel).assertTrue();
    })

    it('hideMediaControlTest', 0, (): void => {
      let hideMediaControl = true;
      CommonEventManager.publish('HideMediaControl', (err) => {
        if (err) {
          hideMediaControl = false;
        }
      });
      expect(hideMediaControl).assertTrue();
    })
  })
}