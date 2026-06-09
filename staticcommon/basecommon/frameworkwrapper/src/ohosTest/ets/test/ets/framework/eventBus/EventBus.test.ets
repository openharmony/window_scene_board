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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { EvtBus, EventManager, EventListener, EventProduce, QuickOff } from '../../../../../../main/ets/eventbus/EventBus';
import { CommonEvent, PackageCommonEvent } from '../../../../../../main/ets/eventbus/events/CommonEvents';

class mTestEventB extends CommonEvent {
  static testData: String = 'mTest';
};

let mEventManager: EventManager = new EventManager();
let mCallBack: EventListener<PackageCommonEvent> = (data: PackageCommonEvent): void => {};
let mCallBackB: EventListener<mTestEventB> = (data: mTestEventB): void => {};
let mProducer: EventProduce<PackageCommonEvent> = (param?: String): PackageCommonEvent => new PackageCommonEvent({
  event:'mTest',
  bundleName:'',
  code:0,
  data:''
});
let mProducerB: EventProduce<mTestEventB> = (param?: String): mTestEventB => new mTestEventB({
  event:'mTest',
  bundleName:'',
  code:0,
  data:''
});

export function EventBusTest() {
  describe('EventBusTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('EventBusTest_registerEventListener', 0, (): void => {
      expect(EvtBus.on(null, null)).assertInstanceOf('Function');
      EvtBus.on(PackageCommonEvent, null);
      EvtBus.on(PackageCommonEvent, mCallBack);
      EvtBus.on(mTestEventB, mCallBackB);
      expect(EvtBus.on(PackageCommonEvent, mCallBack)).assertInstanceOf('Function');
    })

    it('EventBusTest_registerEventListenerOnce', 0, (): void => {
      expect(EvtBus.once(null, null)).assertInstanceOf('Function');
      EvtBus.once(PackageCommonEvent, null);
      EvtBus.once(PackageCommonEvent, mCallBack);
    })

    it('EventBusTest_unregisterEventListener', 0, (): void => {
      EvtBus.off(null, null);
      EvtBus.off(mTestEventB,mCallBackB);
      expect(EvtBus.off(PackageCommonEvent, mCallBack) === undefined).assertTrue();
    })

    it('EventBusTest_postEvent', 0, (): void => {
      EvtBus.post(null, null);
      let mTestEvt: PackageCommonEvent = new PackageCommonEvent({
        event:'mTest',
        bundleName:'',
        code:0,
        data:''
      });
      EvtBus.post(PackageCommonEvent, mTestEvt);
      let mTestEvtB: mTestEventB = new mTestEventB({
        event:'mTest',
        bundleName:'',
        code:0,
        data:''
      })
      expect(EvtBus.post(mTestEventB, mTestEvtB) === undefined).assertTrue();
    })

    it('EventBusTest_registerProduce', 0, (): void => {
      EvtBus.produceOn(null, null);
      EvtBus.produceOn(PackageCommonEvent, null);
      EvtBus.produceOn(PackageCommonEvent, mProducer);
      EvtBus.produceOn(PackageCommonEvent, mProducer);
      expect(EvtBus.produceOn(mTestEventB, mProducerB)).assertInstanceOf('Function');
    })

    it('EventBusTest_unregisterProduce', 0, (): void => {
      EvtBus.produceOff(null, null);
      EvtBus.produceOff(mTestEventB, mProducerB);
      EvtBus.produceOff(PackageCommonEvent, mProducer);
      expect(true).assertTrue();
    })

    it('EventManagerTest_registerEvent_invalid_offList', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(EvtBus, EvtBus.on);
      when(mockFunc)(PackageCommonEvent).afterReturn([null]);
      mEventManager.on(PackageCommonEvent, mCallBack);
      expect(true).assertTrue();
      mocker.clear(EvtBus);
      mocker.clearAll();
    })

    it('EventManagerTest_registerEvent_valid_offList', 0, (): void => {
      let mOff: QuickOff = (): void => {};
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(EvtBus, EvtBus.on);
      when(mockFunc)(PackageCommonEvent).afterReturn([mOff]);
      mEventManager.on(PackageCommonEvent, mCallBack);
      expect(true).assertTrue();
      mocker.clear(EvtBus);
      mocker.clearAll();
    })

    it('EventManagerTest_addOff', 0, (): void => {
      let mOff: QuickOff = (): void => {}
      mEventManager.addOff(null);
      mEventManager.addOff(mOff);
      expect(true).assertTrue();
    })
  })
}