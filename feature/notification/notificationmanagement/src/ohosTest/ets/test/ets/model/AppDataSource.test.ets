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
import {LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { describe, beforeEach, afterEach, it, expect, when, ArgumentMatchers, MockKit } from '@ohos/hypium';
import AppLiveViewDataSource from '../../../../../main/ets/model/AppDataSource';

export default function AppLiveViewDataSourceTest() {
  describe('registerDataChangeListener_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists01', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist01', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists02', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist02', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists03', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist03', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists04', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist04', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists01', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist01', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists02', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist02', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists03', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist03', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists04', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist04', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists01', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist01', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists02', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist02', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists03', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist03', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists04', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist04', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists01', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist01', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists02', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist02', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists03', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist03', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists04', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist04', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_listener_when_listener_does_not_exist', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_not_add_listener_when_listener_already_exists', 0, () => {
      let appliveviewdatasource: AppLiveViewDataSource = new AppLiveViewDataSource([]);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let listener: DataChangeListener = new DataChangeListener();
      appliveviewdatasource.registerDataChangeListener(listener);
      appliveviewdatasource.registerDataChangeListener(listener);

      expect(appliveviewdatasource.listeners.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

  });
}
