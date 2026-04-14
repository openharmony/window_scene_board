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

import { afterAll, beforeAll, it, describe, expect, MockKit, when } from '@ohos/hypium';
import { CommonData } from '@ohos/screenlockcommon';
import { KmShareToggleController } from '../../../../main/ets/com/ohos/controller/KmShareToggleController';

const sKmShareController = KmShareToggleController.getInstance();

export function KmShareToggleControllerTest() {
  describe('KmShareToggleControllerTest', (): void => {
    beforeAll((): void => {
      sKmShareController.onStart();
    });

    afterAll((): void => {
      sKmShareController.onStop();
    });
    it('isAvailableTest', 0, isAvailableTest);
    it('isLoadLottieTest', 0, isLoadLottieTest);
    it('handleLongClickTest', 0, handleLongClickTest);
    it('getDataTest', 0, getDataTest);
    it('setStatusBarVisible', 0, setStatusBarVisible);
    it('changeConnectStatus', 0, changeConnectStatus);
    it('sendRemoteRequest', 0, sendRemoteRequest);
  })
}

function isAvailableTest() {
  let isAvailable: boolean = sKmShareController.isAvailable();
  expect(isAvailable).assertTrue();
}

function isLoadLottieTest() {
  let isLoadLottie: boolean = true;
  isLoadLottie = sKmShareController.isLoadLottie();
  expect(isLoadLottie).assertFalse();
}

function handleLongClickTest() {
  let longClick: boolean = true;
  longClick = sKmShareController.handleLongClick();
  expect(longClick).assertFalse();
}

function getDataTest() {
  let data: CommonData | undefined = undefined;
  data = sKmShareController.getData();
  expect(data).not().assertUndefined();
}

function setStatusBarVisible() {
  let statusBar: boolean = false;
  let fun: Function = new MockKit().mockFunc(sKmShareController, sKmShareController.setStatusBarVisible);
  when(fun)(true).afterAction(() => {
    statusBar = true;
  });
  sKmShareController.setStatusBarVisible(true);
  expect(statusBar).assertTrue();
}

function changeConnectStatus() {
  sKmShareController.getData().status = false;
  sKmShareController.changeConnectStatus(true);
  expect(sKmShareController.getData().status).assertTrue();
}

function sendRemoteRequest() {
  let statusBar: boolean = false;
  let fun: Function = new MockKit().mockFunc(sKmShareController, sKmShareController.sendRemoteRequest);
  when(fun)(true).afterAction(() => {
    statusBar = true;
  });
  sKmShareController.sendRemoteRequest();
  expect(statusBar).assertTrue();
}