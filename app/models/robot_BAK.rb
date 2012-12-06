#     doc.css('#conditions').each do |node|
#         Rails.logger.debug('Test content :  ' + node.content)
#     end 

#     Rails.logger.debug(">>>>>>> Conditions <<<<<<<")
#     Rails.logger.debug(doc.css("#conditions")[0].text)


#     Rails.logger.debug(">>>>>>> Tableau sportif <<<<<<<")

#     Rails.logger.debug(doc.to_s)
#     doc.css('#Sport4Tab tr.normal').each do |tr|
# #.ControlContent
#         Rails.logger.debug(tr.to_s)
#         next

#         tr.search('td').each do |second_td|
#             Rails.logger.debug('In first search for TD')
            
#             final_tr = second_td.search('table tbody tr')
#             td_label = final_tr.search('td.label')
#             td_odd = final_tr.search('td.odd')

#             if td_label
#                 Rails.logger.debug('Label :  ' + td_label.content)
#             else
#                 Rails.logger.debug('Label is null')
#             end
#             if td_odd
#                 Rails.logger.debug('Label :  ' + td_odd.content)
#             else
#                 Rails.logger.debug('Odd is null')
#             end
#         end
#     end