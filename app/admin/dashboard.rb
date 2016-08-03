ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

    content title: proc{ I18n.t("active_admin.dashboard") } do
        # render partial: 'welcome'

        # li link_to("Tomorrow's Inspections", "inspections?utf8=%E2%9C%93&q%5Brequested_for_date_gteq_date%5D=#{next_inspection_day_date.strftime('%Y-%m-%d')}&q%5Brequested_for_date_lteq_date%5D=#{next_inspection_day_date.strftime('%Y-%m-%d')}&commit=Filter&order=id_desc")

        # div line_chart Inspection.where("requested_for_date > ? and requested_for_date < ?", Date.today-30.days, 2.business_days.from_now.to_date).group_by_day(:requested_for_date).count

        columns do
            link_to "Schedule an Inspection", "/inspections/new_express", class: "button"
        end

        columns do
            column span: 3 do
                link_to "Print Last Day's Inspections", "/inspections_print?date=#{ last_inspection_day_date }", class: "button"
            end
            column span: 3 do
                link_to "Print Today's Inspections", "/inspections_print?date=#{ Date.today }", class: "button"
            end
            column span: 3 do
                link_to "Print Tomorrow's Inspections", "/inspections_print?date=#{ next_inspection_day_date }", class: "button"
            end
        end

        panel "Inspections by Day" do
            div line_chart Inspection.where("requested_for_date > ? and requested_for_date < ?", Date.today-30.days, 2.business_days.from_now.to_date).group_by_day(:requested_for_date).count
        end

        columns do
            column span: 2 do
                link_to "View Daily Report", "/admin/inspections?utf8=%E2%9C%93&q%5Brequested_for_date_gteq_date%5D=#{next_inspection_day_date.strftime('%Y-%m-%d')}&q%5Brequested_for_date_lteq_date%5D=#{next_inspection_day_date.strftime('%Y-%m-%d')}&commit=Filter&order=id_desc", class: "button"
            end
            column do
                link_to "View 30-Day Report", reports_period_path, class: "button"
            end
        end

    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
    # content
end
