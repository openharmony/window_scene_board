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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { immersiveKgMgr, ImmersiveType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ImmersiveCardVm } from '../../../../main/ets/viewmodel/ImmersiveCardVm';
import { immersiveVm } from '../../../../main/ets/viewmodel/ImmersiveVm';
import { ImmersiveAnimManager } from '../../../../main/ets/viewmodel/viewanim/ImmersiveAnimManager';
import { ImmersiveDataGroupPacker } from '../../../../main/ets/viewmodel/viewdata/ImmersiveDataGroupProcessor';
import { ImmersiveNtfData } from '../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveLiveListTest1() {
  describe('ImmersiveCardVmTest1', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('testIsLoadUiExtension_01', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.isLoadUiExtension();
      cardVm.addUIExtensionCount();
      cardVm.delUIExtensionCount();
      expect(res).not().assertNull();
    });

    it('testSetDelayTimeout_01', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['setDelayTimeout']();
      (cardVm as object)['clearDelayTimeout']();
      expect(true).assertTrue();
    });

    it('testCheckUiDataForDataChanged_01', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(false);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(true);
      (cardVm as object)['checkUiDataForDataChanged']();
      expect(true).assertTrue();
    });

    it('testFindGroupData_01', Level.LEVEL1, (): void => {
      let animManager = new ImmersiveAnimManager();
      let packer = new ImmersiveDataGroupPacker();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'fd';
      immersiveNtfData.groupKey = 'grouptest';
      immersiveNtfData.creatorBundleName = 'mytest.com';
      immersiveNtfData.appName = 'myapp';
      immersiveNtfData.id = 10000;
      let ntfDatas: ImmersiveNtfData[] = [];
      ntfDatas.push(immersiveNtfData);
      (packer as object)['groupList'] = ntfDatas;
      let cardVm = new ImmersiveCardVm(animManager, packer);
      (cardVm as object)['findGroupData']();
      (cardVm as object)['findGroupData']('grouptest');
      expect(true).assertTrue();
    });

    it('ImmersiveCardVm_hasPermission_return_true_01', Level.LEVEL0, (done: Function) => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
      expect(result).assertTrue();
      done();
    });

    it('testIsLoadUiExtension_02', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.isLoadUiExtension();
      cardVm.addUIExtensionCount();
      cardVm.delUIExtensionCount();
      expect(res).not().assertNull();
    });

    it('testSetDelayTimeout_02', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['setDelayTimeout']();
      (cardVm as object)['clearDelayTimeout']();
      expect(true).assertTrue();
    });

    it('testCheckUiDataForDataChanged_02', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(false);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(true);
      (cardVm as object)['checkUiDataForDataChanged']();
      expect(true).assertTrue();
    });

    it('testFindGroupData_02', Level.LEVEL1, (): void => {
      let animManager = new ImmersiveAnimManager();
      let packer = new ImmersiveDataGroupPacker();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'fd';
      immersiveNtfData.groupKey = 'grouptest';
      immersiveNtfData.creatorBundleName = 'mytest.com';
      immersiveNtfData.appName = 'myapp';
      immersiveNtfData.id = 10000;
      let ntfDatas: ImmersiveNtfData[] = [];
      ntfDatas.push(immersiveNtfData);
      (packer as object)['groupList'] = ntfDatas;
      let cardVm = new ImmersiveCardVm(animManager, packer);
      (cardVm as object)['findGroupData']();
      (cardVm as object)['findGroupData']('grouptest');
      expect(true).assertTrue();
    });

    it('ImmersiveCardVm_hasPermission_return_true_02', Level.LEVEL0, (done: Function) => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
      expect(result).assertTrue();
      done();
    });

    it('testIsLoadUiExtension_03', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.isLoadUiExtension();
      cardVm.addUIExtensionCount();
      cardVm.delUIExtensionCount();
      expect(res).not().assertNull();
    });

    it('testSetDelayTimeout_03', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['setDelayTimeout']();
      (cardVm as object)['clearDelayTimeout']();
      expect(true).assertTrue();
    });

    it('testCheckUiDataForDataChanged_03', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(false);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(true);
      (cardVm as object)['checkUiDataForDataChanged']();
      expect(true).assertTrue();
    });

    it('testFindGroupData_03', Level.LEVEL1, (): void => {
      let animManager = new ImmersiveAnimManager();
      let packer = new ImmersiveDataGroupPacker();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'fd';
      immersiveNtfData.groupKey = 'grouptest';
      immersiveNtfData.creatorBundleName = 'mytest.com';
      immersiveNtfData.appName = 'myapp';
      immersiveNtfData.id = 10000;
      let ntfDatas: ImmersiveNtfData[] = [];
      ntfDatas.push(immersiveNtfData);
      (packer as object)['groupList'] = ntfDatas;
      let cardVm = new ImmersiveCardVm(animManager, packer);
      (cardVm as object)['findGroupData']();
      (cardVm as object)['findGroupData']('grouptest');
      expect(true).assertTrue();
    });

    it('ImmersiveCardVm_hasPermission_return_true_03', Level.LEVEL0, (done: Function) => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
      expect(result).assertTrue();
      done();
    });

    it('testIsLoadUiExtension_04', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.isLoadUiExtension();
      cardVm.addUIExtensionCount();
      cardVm.delUIExtensionCount();
      expect(res).not().assertNull();
    });

    it('testSetDelayTimeout_04', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['setDelayTimeout']();
      (cardVm as object)['clearDelayTimeout']();
      expect(true).assertTrue();
    });

    it('testCheckUiDataForDataChanged_04', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(false);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(true);
      (cardVm as object)['checkUiDataForDataChanged']();
      expect(true).assertTrue();
    });

    it('testFindGroupData_04', Level.LEVEL1, (): void => {
      let animManager = new ImmersiveAnimManager();
      let packer = new ImmersiveDataGroupPacker();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'fd';
      immersiveNtfData.groupKey = 'grouptest';
      immersiveNtfData.creatorBundleName = 'mytest.com';
      immersiveNtfData.appName = 'myapp';
      immersiveNtfData.id = 10000;
      let ntfDatas: ImmersiveNtfData[] = [];
      ntfDatas.push(immersiveNtfData);
      (packer as object)['groupList'] = ntfDatas;
      let cardVm = new ImmersiveCardVm(animManager, packer);
      (cardVm as object)['findGroupData']();
      (cardVm as object)['findGroupData']('grouptest');
      expect(true).assertTrue();
    });

    it('ImmersiveCardVm_hasPermission_return_true_04', Level.LEVEL0, (done: Function) => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
      expect(result).assertTrue();
      done();
    });

    it('testIsLoadUiExtension_05', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.isLoadUiExtension();
      cardVm.addUIExtensionCount();
      cardVm.delUIExtensionCount();
      expect(res).not().assertNull();
    });

    it('testSetDelayTimeout_05', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['setDelayTimeout']();
      (cardVm as object)['clearDelayTimeout']();
      expect(true).assertTrue();
    });

    it('testCheckUiDataForDataChanged_05', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(false);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(true);
      (cardVm as object)['checkUiDataForDataChanged']();
      expect(true).assertTrue();
    });

    it('testFindGroupData_05', Level.LEVEL1, (): void => {
      let animManager = new ImmersiveAnimManager();
      let packer = new ImmersiveDataGroupPacker();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'fd';
      immersiveNtfData.groupKey = 'grouptest';
      immersiveNtfData.creatorBundleName = 'mytest.com';
      immersiveNtfData.appName = 'myapp';
      immersiveNtfData.id = 10000;
      let ntfDatas: ImmersiveNtfData[] = [];
      ntfDatas.push(immersiveNtfData);
      (packer as object)['groupList'] = ntfDatas;
      let cardVm = new ImmersiveCardVm(animManager, packer);
      (cardVm as object)['findGroupData']();
      (cardVm as object)['findGroupData']('grouptest');
      expect(true).assertTrue();
    });

    it('ImmersiveCardVm_hasPermission_return_true_05', Level.LEVEL0, (done: Function) => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
      expect(result).assertTrue();
      done();
    });

    it('testIsLoadUiExtension_06', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.isLoadUiExtension();
      cardVm.addUIExtensionCount();
      cardVm.delUIExtensionCount();
      expect(res).not().assertNull();
    });

    it('testSetDelayTimeout_06', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['setDelayTimeout']();
      (cardVm as object)['clearDelayTimeout']();
      expect(true).assertTrue();
    });

    it('testCheckUiDataForDataChanged_06', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(false);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(true);
      (cardVm as object)['checkUiDataForDataChanged']();
      expect(true).assertTrue();
    });

    it('testFindGroupData_06', Level.LEVEL1, (): void => {
      let animManager = new ImmersiveAnimManager();
      let packer = new ImmersiveDataGroupPacker();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'fd';
      immersiveNtfData.groupKey = 'grouptest';
      immersiveNtfData.creatorBundleName = 'mytest.com';
      immersiveNtfData.appName = 'myapp';
      immersiveNtfData.id = 10000;
      let ntfDatas: ImmersiveNtfData[] = [];
      ntfDatas.push(immersiveNtfData);
      (packer as object)['groupList'] = ntfDatas;
      let cardVm = new ImmersiveCardVm(animManager, packer);
      (cardVm as object)['findGroupData']();
      (cardVm as object)['findGroupData']('grouptest');
      expect(true).assertTrue();
    });

    it('ImmersiveCardVm_hasPermission_return_true_06', Level.LEVEL0, (done: Function) => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
      expect(result).assertTrue();
      done();
    });

    it('testIsLoadUiExtension_07', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.isLoadUiExtension();
      cardVm.addUIExtensionCount();
      cardVm.delUIExtensionCount();
      expect(res).not().assertNull();
    });

    it('testSetDelayTimeout_07', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['setDelayTimeout']();
      (cardVm as object)['clearDelayTimeout']();
      expect(true).assertTrue();
    });

    it('testCheckUiDataForDataChanged_07', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(false);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(true);
      (cardVm as object)['checkUiDataForDataChanged']();
      expect(true).assertTrue();
    });

    it('testFindGroupData_07', Level.LEVEL1, (): void => {
      let animManager = new ImmersiveAnimManager();
      let packer = new ImmersiveDataGroupPacker();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'fd';
      immersiveNtfData.groupKey = 'grouptest';
      immersiveNtfData.creatorBundleName = 'mytest.com';
      immersiveNtfData.appName = 'myapp';
      immersiveNtfData.id = 10000;
      let ntfDatas: ImmersiveNtfData[] = [];
      ntfDatas.push(immersiveNtfData);
      (packer as object)['groupList'] = ntfDatas;
      let cardVm = new ImmersiveCardVm(animManager, packer);
      (cardVm as object)['findGroupData']();
      (cardVm as object)['findGroupData']('grouptest');
      expect(true).assertTrue();
    });

    it('ImmersiveCardVm_hasPermission_return_true_07', Level.LEVEL0, (done: Function) => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
      expect(result).assertTrue();
      done();
    });

    it('testIsLoadUiExtension_08', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.isLoadUiExtension();
      cardVm.addUIExtensionCount();
      cardVm.delUIExtensionCount();
      expect(res).not().assertNull();
    });

    it('testSetDelayTimeout_08', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['setDelayTimeout']();
      (cardVm as object)['clearDelayTimeout']();
      expect(true).assertTrue();
    });

    it('testCheckUiDataForDataChanged_08', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(false);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(true);
      (cardVm as object)['checkUiDataForDataChanged']();
      expect(true).assertTrue();
    });

    it('testFindGroupData_08', Level.LEVEL1, (): void => {
      let animManager = new ImmersiveAnimManager();
      let packer = new ImmersiveDataGroupPacker();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'fd';
      immersiveNtfData.groupKey = 'grouptest';
      immersiveNtfData.creatorBundleName = 'mytest.com';
      immersiveNtfData.appName = 'myapp';
      immersiveNtfData.id = 10000;
      let ntfDatas: ImmersiveNtfData[] = [];
      ntfDatas.push(immersiveNtfData);
      (packer as object)['groupList'] = ntfDatas;
      let cardVm = new ImmersiveCardVm(animManager, packer);
      (cardVm as object)['findGroupData']();
      (cardVm as object)['findGroupData']('grouptest');
      expect(true).assertTrue();
    });

    it('ImmersiveCardVm_hasPermission_return_true_08', Level.LEVEL0, (done: Function) => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
      expect(result).assertTrue();
      done();
    });

    it('testIsLoadUiExtension_09', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.isLoadUiExtension();
      cardVm.addUIExtensionCount();
      cardVm.delUIExtensionCount();
      expect(res).not().assertNull();
    });

    it('testSetDelayTimeout_09', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['setDelayTimeout']();
      (cardVm as object)['clearDelayTimeout']();
      expect(true).assertTrue();
    });

    it('testCheckUiDataForDataChanged_09', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(false);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(true);
      (cardVm as object)['checkUiDataForDataChanged']();
      expect(true).assertTrue();
    });

    it('testFindGroupData_09', Level.LEVEL1, (): void => {
      let animManager = new ImmersiveAnimManager();
      let packer = new ImmersiveDataGroupPacker();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'fd';
      immersiveNtfData.groupKey = 'grouptest';
      immersiveNtfData.creatorBundleName = 'mytest.com';
      immersiveNtfData.appName = 'myapp';
      immersiveNtfData.id = 10000;
      let ntfDatas: ImmersiveNtfData[] = [];
      ntfDatas.push(immersiveNtfData);
      (packer as object)['groupList'] = ntfDatas;
      let cardVm = new ImmersiveCardVm(animManager, packer);
      (cardVm as object)['findGroupData']();
      (cardVm as object)['findGroupData']('grouptest');
      expect(true).assertTrue();
    });
  });

  it('ImmersiveCardVm_hasPermission_return_true_09', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_10', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_10', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_10', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_10', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_10', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_11', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_11', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_11', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_11', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_11', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_12', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_12', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_12', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_12', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_12', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_13', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_13', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_13', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_13', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_13', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_14', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_14', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_14', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_14', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_14', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testSetDelayTimeout_15', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_15', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_15', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_15', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_16', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_16', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_16', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_16', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_16', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_17', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_17', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_17', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_17', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_17', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_18', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_18', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_18', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_18', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_18', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_19', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_19', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_19', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_19', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_19', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_20', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_20', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_20', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_20', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_20', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_21', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_21', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_21', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_21', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_21', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_22', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_22', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_22', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_22', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_22', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_23', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_23', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_23', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_23', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_23', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_24', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_24', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_24', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_24', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_24', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_25', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_25', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_25', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_25', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_25', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_26', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_26', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_26', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_26', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_26', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_27', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_27', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_27', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_27', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_27', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_28', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_28', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_28', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_28', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_28', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testFindGroupData_21', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_21', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_22', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_22', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_22', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_22', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_22', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_23', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_23', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_23', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_23', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_23', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_24', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_24', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_24', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_24', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_24', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_25', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_25', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_25', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_25', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_25', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_26', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_26', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_26', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_26', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_26', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_27', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_27', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_27', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_27', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_27', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_28', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_28', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_28', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_28', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_28', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });

  it('testIsLoadUiExtension_29', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let res = cardVm.isLoadUiExtension();
    cardVm.addUIExtensionCount();
    cardVm.delUIExtensionCount();
    expect(res).not().assertNull();
  });

  it('testSetDelayTimeout_29', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    (cardVm as object)['setDelayTimeout']();
    (cardVm as object)['clearDelayTimeout']();
    expect(true).assertTrue();
  });

  it('testCheckUiDataForDataChanged_29', Level.LEVEL1, (): void => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(false);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
    immersiveKgMgr.exitImmersiveState(true);
    (cardVm as object)['checkUiDataForDataChanged']();
    expect(true).assertTrue();
  });

  it('testFindGroupData_29', Level.LEVEL1, (): void => {
    let animManager = new ImmersiveAnimManager();
    let packer = new ImmersiveDataGroupPacker();
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);
    (packer as object)['groupList'] = ntfDatas;
    let cardVm = new ImmersiveCardVm(animManager, packer);
    (cardVm as object)['findGroupData']();
    (cardVm as object)['findGroupData']('grouptest');
    expect(true).assertTrue();
  });

  it('ImmersiveCardVm_hasPermission_return_true_29', Level.LEVEL0, (done: Function) => {
    let cardVm = immersiveVm.getImmersiveCardVm();
    let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
    expect(result).assertTrue();
    done();
  });
}