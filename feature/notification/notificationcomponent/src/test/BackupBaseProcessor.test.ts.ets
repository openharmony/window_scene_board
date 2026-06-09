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
import { CloneParam, BackupBaseProcessor } from '../../../main/ets/backup/BackupBaseProcessor';
import { Context } from '@kit.AbilityKit';
import { NotificationBackupManager } from '../../../main/ets/backup/NotificationBackupManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BitUtil, NotificationConfigEntity, notificationStore } from '@ohos/systemuicommon';
import { NotificationBackupAppSettingStore } from '../../../main/ets/backup/database/NotificationBackupAppSettingStore';
import { NotificationBackupConfigEntity } from '../../../main/ets/backup/model/NotificationBackupConfigEntity';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { Hm2HmCloneBackupProcessor } from '../../../main/ets/backup/Hm2HmCloneBackupProcessor';
export default function Hm2HmCloneBackupProcessorTest() {
  describe('backupPathList_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });
    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();

      expect(result.length).assertEqual(3);

      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);

      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();
      expect(result.length).assertEqual(3);
      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);
      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);

      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });
    it('should_return_correct_backup_path_list', 0, () => {
      let context: Context = new Context();
      let processor: Hm2HmCloneBackupProcessor = new Hm2HmCloneBackupProcessor(context);
      let result: CloneParam[] = processor.backupPathList();
      expect(result.length).assertEqual(3);
      expect(result[0].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[0].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[0].sourceFile).assertEqual(NTF_SETTING_FILE);
      expect(result[0].targetFile).assertEqual(NTF_SETTING_BACK_UP_FILE);
      expect(result[1].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[1].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[1].sourceFile).assertEqual(NTF_SETTING_SHM_FILE);
      expect(result[1].targetFile).assertEqual(NTF_SETTING_BACK_UP_SHM_FILE);
      expect(result[2].sourcePath).assertEqual(processor.baseBackupPath + NTF_SETTING_PATH);
      expect(result[2].targetPath).assertEqual(processor.baseRestorePath);
      expect(result[2].sourceFile).assertEqual(NTF_SETTING_WAL_FILE);
      expect(result[2].targetFile).assertEqual(NTF_SETTING_BACK_UP_WAL_FILE);
    });

  });
}