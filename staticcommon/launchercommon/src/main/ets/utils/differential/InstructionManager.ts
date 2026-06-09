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

import { SingleBase, SingleContext, singleManager } from '@ohos/basicutils';
import type GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { ClearInstruction } from './ClearInstruction';
import { DefaultInstruction } from './DefaultInstruction';
import PlusOneScreenInstruction from './PlusOneScreenInstruction';
import type { Instruction } from './Instruction';
import ModifyInstruction from './ModifyInstruction';
import { DeleteInstruction } from './DeleteInstruction';
import { InsertInstruction } from './InsertInstruction';
import { InsertIntoInstruction } from './InsertIntoInstruction';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LayoutViewModel } from '../../viewmodel/LayoutViewModel';
import { AddInstruction } from './AddInstruction';
import { UpdateFormStackItemInstruction } from './UpdateFormStackItemInstruction';
import { AddToFolderInstruction } from './AddToFolderInstruction';
import { ReplaceInstruction } from './ReplaceInstruction';


const TAG = 'InstructionManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 指定的差分指令集合
 */
export const enum InstructionType {
  CLEAR = 'clear',
  DEFAULT = 'default',
  MODIFY = 'modify',
  SCREEN_PLUS_ONE = 'screen+1',
  DELETE = 'delete',
  INSERT = 'insert',
  ADD = 'add',
  INSERT_INTO = 'insertinto',
  UPDATE_FORMSTACK_ITEM = 'updateFormStackItem',
  ADD_TO_FOLDER = 'addtofolder',
  REPLACE = 'replace'
}

/**
 * 差分指令管理类，负责差分指令的初始化，差分指令的分发处理
 */
export class InstructionManager extends SingleBase {
  public static singleName: string = 'InstructionManager';
  private instructions: Record<string, Instruction> = {};

  public constructor(ctx?: SingleContext) {
    super(ctx);
    let res = LayoutViewModel.getInstance(this.singleContext).calculateDesktop();
    const rows = res.mRows ?? 0;
    const columns = res.mColumns ?? 0;
    log.showInfo(`calculateDesktop -> rows = ${rows}`);
    log.showInfo(`calculateDesktop -> columns = ${columns}`);
    if (rows < 1 || columns < 1) {
      return;
    }
    this.registerCommand(InstructionType.CLEAR, new ClearInstruction(rows, columns));
    this.registerCommand(InstructionType.MODIFY, new ModifyInstruction(rows, columns));
    this.registerCommand(InstructionType.DEFAULT, new DefaultInstruction(rows, columns));
    this.registerCommand(InstructionType.SCREEN_PLUS_ONE, new PlusOneScreenInstruction(rows, columns));
    this.registerCommand(InstructionType.DELETE, new DeleteInstruction(rows, columns));
    this.registerCommand(InstructionType.INSERT, new InsertInstruction(rows, columns));
    this.registerCommand(InstructionType.ADD, new AddInstruction(rows, columns));
    this.registerCommand(InstructionType.INSERT_INTO, new InsertIntoInstruction(rows, columns));
    this.registerCommand(InstructionType.UPDATE_FORMSTACK_ITEM, new UpdateFormStackItemInstruction(rows, columns));
    this.registerCommand(InstructionType.ADD_TO_FOLDER, new AddToFolderInstruction(rows, columns));
    this.registerCommand(InstructionType.REPLACE, new ReplaceInstruction(rows, columns));
  }

  /**
   * 获取单实例指令管理器
   *
   * @returns 返回指令管理器
   */
  static getInstance(ctx?: SingleContext): InstructionManager {
    return singleManager.get<InstructionManager>(InstructionManager, ctx);
  }

  /**
   * 差分指令注册方法
   *
   * @param name 差分指令名称
   * @param command 差分指令对应的解析器
   */
  registerCommand(name: string, command: Instruction): void {
    log.showInfo(`registerCommand -> name = ${name}`);
    this.instructions[name] = command;
  }

  /**
   * 执行差分命令
   *
   * @param command 差分指令
   * @param gridLayoutList 原始的布局信息
   * @param gridLayout 需要插入的布局元素
   * @returns 差分处理以后的布局信息
   */
  executeCommand(command: string | undefined, gridLayoutList: GridLayoutItemInfo[], gridLayout: GridLayoutItemInfo): GridLayoutItemInfo[] {
    log.showInfo(`executeCommand -> command: ${command}`);
    if (typeof command === 'string') {
      const exeCommand = this.instructions[command];
      if (exeCommand != null) {
        return exeCommand.execute(gridLayoutList, gridLayout);
      } else {
        log.showInfo(`the command: ${command} is not exist!`);
      }
    }
    return this.instructions[InstructionType.DEFAULT].execute(gridLayoutList, gridLayout);
  }
}


